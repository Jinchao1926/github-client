import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:github_client/services/api/api_client.dart';
import 'package:github_client/services/api/user_service.dart';
import 'package:github_client/services/auth/github_oauth_service.dart';
import 'package:github_client/models/github_auth_session.dart';

void main() {
  test('createCodeChallenge returns URL-safe non-empty string', () {
    const verifier = 'plain-text-code-verifier-1234567890';

    final challenge = GitHubOAuthService.createCodeChallenge(verifier);

    expect(challenge, isNotEmpty);
    expect(challenge.contains('+'), isFalse);
    expect(challenge.contains('/'), isFalse);
    expect(challenge.contains('='), isFalse);
  });

  test('ApiClient exposes configured Dio instance', () {
    final apiClient = ApiClient();

    expect(apiClient.dio, isA<Dio>());
  });

  test('ApiClient configures default Dio timeouts', () {
    final apiClient = ApiClient();

    expect(apiClient.dio.options.connectTimeout, const Duration(seconds: 30));
    expect(apiClient.dio.options.receiveTimeout, const Duration(seconds: 30));
    expect(apiClient.dio.options.sendTimeout, const Duration(seconds: 30));
  });

  test('ApiClient adds a log interceptor by default', () {
    final apiClient = ApiClient();

    expect(
      apiClient.dio.interceptors.any(
        (interceptor) => interceptor is LogInterceptor,
      ),
      isTrue,
    );
  });

  test('ApiClient configures GitHub base URL and accept header', () {
    final apiClient = ApiClient();

    expect(apiClient.dio.options.baseUrl, 'https://api.github.com');
    expect(
      apiClient.dio.options.headers['Accept'],
      'application/vnd.github+json',
    );
  });

  test(
    'ApiClient injects bearer token when token provider returns one',
    () async {
      final apiClient = ApiClient(tokenProvider: () async => 'token-123');
      String? authorizationHeader;

      apiClient.dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            authorizationHeader = options.headers['Authorization'] as String?;
            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {'ok': true},
              ),
            );
          },
        ),
      );

      await apiClient.dio.get('/user');

      expect(authorizationHeader, 'Bearer token-123');
    },
  );

  test('GitHubOAuthService parses GitHub App session payload', () {
    final session = GitHubAuthSession.fromTokenResponse({
      'access_token': 'access-token',
      'expires_in': 28800,
      'refresh_token': 'refresh-token',
      'refresh_token_expires_in': 15897600,
    }, now: DateTime.utc(2026, 4, 24, 10));

    expect(session.accessToken, 'access-token');
    expect(session.refreshToken, 'refresh-token');
    expect(session.accessTokenExpiresAt, DateTime.utc(2026, 4, 24, 18));
    expect(session.refreshTokenExpiresAt, DateTime.utc(2026, 10, 25, 10));
  });

  test('GitHubOAuthService refreshes a GitHub App user token', () async {
    late Object? requestData;
    final dio = Dio()
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.uri.toString() ==
                'https://github.com/login/oauth/access_token') {
              requestData = options.data;
              handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'access_token': 'rotated-access',
                    'expires_in': 28800,
                    'refresh_token': 'rotated-refresh',
                    'refresh_token_expires_in': 15897600,
                  },
                ),
              );
              return;
            }

            handler.next(options);
          },
        ),
      );
    final service = GitHubOAuthService(apiClient: ApiClient(dio: dio));

    final session = await service.refreshSession('old-refresh-token');

    expect(requestData, containsPair('grant_type', 'refresh_token'));
    expect(requestData, containsPair('refresh_token', 'old-refresh-token'));
    expect(session.accessToken, 'rotated-access');
    expect(session.refreshToken, 'rotated-refresh');
  });

  test(
    'GitHubApiService fetches current user through shared ApiClient',
    () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://api.github.com'))
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) {
              if (options.path == '/user') {
                handler.resolve(
                  Response(
                    requestOptions: options,
                    statusCode: 200,
                    data: {
                      'login': 'octocat',
                      'name': 'The Octocat',
                      'avatar_url': 'https://example.com/avatar.png',
                      'bio': 'Mascot',
                    },
                  ),
                );
                return;
              }

              handler.next(options);
            },
          ),
        );
      final apiClient = ApiClient(dio: dio);
      final githubApiService = UserService(apiClient: apiClient);

      final response = await githubApiService.getCurrentUser();

      expect(response.login, 'octocat');
    },
  );

  test('GitHubOAuthService fetchCurrentUser uses ApiClient Dio', () async {
    final dio = Dio(BaseOptions(baseUrl: 'https://api.github.com'))
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.path == '/user') {
              handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'login': 'octocat',
                    'name': 'The Octocat',
                    'avatar_url': 'https://example.com/avatar.png',
                    'bio': 'Mascot',
                  },
                ),
              );
              return;
            }

            handler.next(options);
          },
        ),
      );
    final apiClient = ApiClient(dio: dio);
    final service = GitHubOAuthService(apiClient: apiClient);

    final user = await service.fetchCurrentUser();

    expect(user.login, 'octocat');
    expect(user.avatarUrl, 'https://example.com/avatar.png');
  });
}
