import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:github_client/services/api/api_client.dart';
import 'package:github_client/services/api/user_service.dart';
import 'package:github_client/services/auth/github_oauth_service.dart';

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

    expect(apiClient.dio.options.connectTimeout, const Duration(seconds: 15));
    expect(apiClient.dio.options.receiveTimeout, const Duration(seconds: 15));
    expect(apiClient.dio.options.sendTimeout, const Duration(seconds: 15));
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

      expect(response['login'], 'octocat');
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
