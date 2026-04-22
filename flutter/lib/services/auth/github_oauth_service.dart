import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';

import 'package:github_client/config/github_auth_config.dart';
import 'package:github_client/models/github_user.dart';
import 'package:github_client/services/api/api_client.dart';
import 'package:github_client/services/api/user_service.dart';

class GitHubOAuthService {
  GitHubOAuthService({ApiClient? apiClient}) : this._(apiClient ?? ApiClient());

  GitHubOAuthService._(ApiClient apiClient)
    : _apiClient = apiClient,
      _userService = UserService(apiClient: apiClient);

  final ApiClient _apiClient;
  final UserService _userService;

  static final Random _random = Random.secure();
  static const String _charset =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~';

  static String createCodeVerifier() {
    return List.generate(
      64,
      (_) => _charset[_random.nextInt(_charset.length)],
    ).join();
  }

  static String createState() {
    return List.generate(
      32,
      (_) => _charset[_random.nextInt(_charset.length)],
    ).join();
  }

  static String createCodeChallenge(String verifier) {
    final digest = sha256.convert(utf8.encode(verifier));
    return base64UrlEncode(digest.bytes).replaceAll('=', '');
  }

  Future<String> signIn() async {
    final codeVerifier = createCodeVerifier();
    final state = createState();
    final authorizationUri = Uri.parse(GitHubAuthConfig.authorizationEndpoint)
        .replace(
          queryParameters: {
            'client_id': GitHubAuthConfig.clientId,
            'redirect_uri': GitHubAuthConfig.redirectUri,
            // 'scope': GitHubAuthConfig.scopes.join(' '),
            'state': state,
            'response_type': 'code',
            'code_challenge': createCodeChallenge(codeVerifier),
            'code_challenge_method': 'S256',
          },
        );
    debugPrint('clientId=${GitHubAuthConfig.clientId}');
    debugPrint('clientSecret=${GitHubAuthConfig.clientSecret}');

    final callbackUrl = await FlutterWebAuth2.authenticate(
      url: authorizationUri.toString(),
      callbackUrlScheme: GitHubAuthConfig.callbackScheme,
    );

    if (callbackUrl.isEmpty) {
      throw Exception('OAuth callback missing: no URL returned from web auth.');
    }

    final callbackUri = Uri.parse(callbackUrl);

    if (callbackUri.scheme != GitHubAuthConfig.callbackScheme ||
        callbackUri.host != GitHubAuthConfig.callbackHost) {
      throw Exception('OAuth callback URL mismatched: $callbackUri');
    }

    final returnedState = callbackUri.queryParameters['state'];
    final code = callbackUri.queryParameters['code'];
    final error = callbackUri.queryParameters['error'];

    if (error != null && error.isNotEmpty) {
      final desc = callbackUri.queryParameters['error_description'];
      throw Exception(
        'OAuth callback error: $error${desc != null ? ' - $desc' : ''}',
      );
    }

    if (returnedState != state) {
      throw Exception('Invalid OAuth state');
    }

    if (code == null || code.isEmpty) {
      throw Exception('Missing authorization code');
    }

    final response = await _apiClient.dio.post<Map<String, dynamic>>(
      GitHubAuthConfig.tokenEndpoint,
      data: {
        'client_id': GitHubAuthConfig.clientId,
        'client_secret': GitHubAuthConfig.clientSecret,
        'code': code,
        'redirect_uri': GitHubAuthConfig.redirectUri,
        'code_verifier': codeVerifier,
      },
      options: Options(
        headers: {'Accept': 'application/json'},
        contentType: Headers.formUrlEncodedContentType,
      ),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to exchange token');
    }

    final body = response.data;
    final accessToken = body?['access_token'] as String?;
    debugPrint('Token response: $body');

    if (accessToken == null || accessToken.isEmpty) {
      throw Exception('Missing access token');
    }

    return accessToken;
  }

  Future<GitHubUser> fetchCurrentUser() async {
    return await _userService.getCurrentUser();
  }
}
