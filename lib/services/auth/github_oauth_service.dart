import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_github/config/github_auth_config.dart';
import 'package:flutter_github/models/github_user.dart';

class GitHubOAuthService {
  GitHubOAuthService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static final Random _random = Random.secure();
  static const String _charset =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~';

  static String createCodeVerifier() {
    return List.generate(64, (_) => _charset[_random.nextInt(_charset.length)]).join();
  }

  static String createState() {
    return List.generate(32, (_) => _charset[_random.nextInt(_charset.length)]).join();
  }

  static String createCodeChallenge(String verifier) {
    final digest = sha256.convert(utf8.encode(verifier));
    return base64UrlEncode(digest.bytes).replaceAll('=', '');
  }

  Future<String> signIn() async {
    final codeVerifier = createCodeVerifier();
    final state = createState();
    final authorizationUri = Uri.parse(
      GitHubAuthConfig.authorizationEndpoint,
    ).replace(
      queryParameters: {
        'client_id': GitHubAuthConfig.clientId,
        'redirect_uri': GitHubAuthConfig.redirectUri,
        'scope': GitHubAuthConfig.scopes.join(' '),
        'state': state,
        'code_challenge': createCodeChallenge(codeVerifier),
        'code_challenge_method': 'S256',
      },
    );

    final callbackUrl = await FlutterWebAuth2.authenticate(
      url: authorizationUri.toString(),
      callbackUrlScheme: GitHubAuthConfig.callbackScheme,
    );

    final callbackUri = Uri.parse(callbackUrl);
    final returnedState = callbackUri.queryParameters['state'];
    final code = callbackUri.queryParameters['code'];

    if (returnedState != state) {
      throw Exception('Invalid OAuth state');
    }

    if (code == null || code.isEmpty) {
      throw Exception('Missing authorization code');
    }

    final response = await _client.post(
      Uri.parse(GitHubAuthConfig.tokenEndpoint),
      headers: {'Accept': 'application/json'},
      body: {
        'client_id': GitHubAuthConfig.clientId,
        'code': code,
        'redirect_uri': GitHubAuthConfig.redirectUri,
        'code_verifier': codeVerifier,
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to exchange token');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final accessToken = body['access_token'] as String?;

    if (accessToken == null || accessToken.isEmpty) {
      throw Exception('Missing access token');
    }

    return accessToken;
  }

  Future<GitHubUser> fetchCurrentUser(String accessToken) async {
    final response = await _client.get(
      Uri.parse(GitHubAuthConfig.userEndpoint),
      headers: {
        'Accept': 'application/vnd.github+json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load GitHub user');
    }

    return GitHubUser.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }
}
