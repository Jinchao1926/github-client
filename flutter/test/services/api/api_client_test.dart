import 'dart:convert';
import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:github_client/models/github_auth_session.dart';
import 'package:github_client/services/api/api_client.dart';
import 'package:github_client/services/storage/secure_storage_service.dart';

class FakeSecureStorageService extends SecureStorageService {
  FakeSecureStorageService({this.accessToken, this.session});

  final String? accessToken;
  GitHubAuthSession? session;

  @override
  Future<String?> readAccessToken() async {
    return session?.accessToken ?? accessToken;
  }

  @override
  Future<GitHubAuthSession?> readAuthSession() async {
    return session;
  }

  @override
  Future<void> writeAuthSession(GitHubAuthSession nextSession) async {
    session = nextSession;
  }

  @override
  Future<void> deleteAuthSession() async {
    session = null;
  }
}

class CountingAdapter implements HttpClientAdapter {
  int requestCount = 0;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requestCount += 1;
    return ResponseBody.fromString(
      jsonEncode({'count': requestCount}),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

class StubAdapter implements HttpClientAdapter {
  StubAdapter(this.onFetch);

  final Future<ResponseBody> Function(RequestOptions options) onFetch;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) {
    return onFetch(options);
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  setUp(() async {
    await ApiClient.clearCache();
  });

  GitHubAuthSession buildSession({
    required String accessToken,
    required DateTime accessTokenExpiresAt,
    required String refreshToken,
    required DateTime refreshTokenExpiresAt,
  }) {
    return GitHubAuthSession(
      accessToken: accessToken,
      accessTokenExpiresAt: accessTokenExpiresAt,
      refreshToken: refreshToken,
      refreshTokenExpiresAt: refreshTokenExpiresAt,
    );
  }

  test(
    'ApiClient injects bearer token from secure storage by default',
    () async {
      final apiClient = ApiClient(
        storageService: FakeSecureStorageService(accessToken: 'stored-token'),
      );
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

      expect(authorizationHeader, 'Bearer stored-token');
    },
  );

  test(
    'ApiClient does not leak bearer token to non GitHub API hosts',
    () async {
      final apiClient = ApiClient(
        storageService: FakeSecureStorageService(accessToken: 'stored-token'),
      );
      String? githubApiAuthorizationHeader;
      String? oauthAuthorizationHeader;

      apiClient.dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.uri.host == 'api.github.com') {
              githubApiAuthorizationHeader =
                  options.headers['Authorization'] as String?;
            } else if (options.uri.host == 'github.com') {
              oauthAuthorizationHeader =
                  options.headers['Authorization'] as String?;
            }

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
      await apiClient.dio.get('https://github.com/login/oauth/access_token');

      expect(githubApiAuthorizationHeader, 'Bearer stored-token');
      expect(oauthAuthorizationHeader, isNull);
    },
  );

  test('ApiClient caches GitHub GET requests within cache duration', () async {
    final adapter = CountingAdapter();
    final dio = Dio(BaseOptions(baseUrl: 'https://api.github.com'))
      ..httpClientAdapter = adapter;
    final apiClient = ApiClient(
      dio: dio,
      storageService: FakeSecureStorageService(accessToken: 'stored-token'),
    );

    final firstResponse = await apiClient.dio.get('/user');
    final secondResponse = await apiClient.dio.get('/user');

    expect(firstResponse.data, {'count': 1});
    expect(secondResponse.data, {'count': 1});
    expect(adapter.requestCount, 1);
  });

  test(
    'ApiClient expires cached GitHub GET requests after cache duration',
    () async {
      final adapter = CountingAdapter();
      final dio = Dio(BaseOptions(baseUrl: 'https://api.github.com'))
        ..httpClientAdapter = adapter;
      final apiClient = ApiClient(
        dio: dio,
        storageService: FakeSecureStorageService(accessToken: 'stored-token-2'),
        cacheDuration: const Duration(milliseconds: 100),
      );

      final firstResponse = await apiClient.dio.get('/user');
      final cachedResponse = await apiClient.dio.get('/user');
      await Future<void>.delayed(const Duration(milliseconds: 150));
      final refreshedResponse = await apiClient.dio.get('/user');

      expect(firstResponse.data, {'count': 1});
      expect(cachedResponse.data, {'count': 1});
      expect(refreshedResponse.data, {'count': 2});
      expect(adapter.requestCount, 2);
    },
  );

  test(
    'ApiClient refreshes before request when access token is expired',
    () async {
      final storage = FakeSecureStorageService(
        session: buildSession(
          accessToken: 'expired-access',
          accessTokenExpiresAt: DateTime.utc(2026, 4, 24, 8),
          refreshToken: 'refresh-token',
          refreshTokenExpiresAt: DateTime.utc(2026, 5, 24, 10),
        ),
      );
      final dio = Dio(BaseOptions(baseUrl: 'https://api.github.com'))
        ..httpClientAdapter = StubAdapter((options) async {
          if (options.uri.host == 'github.com') {
            expect(options.data, containsPair('grant_type', 'refresh_token'));
            expect(
              options.data,
              containsPair('refresh_token', 'refresh-token'),
            );
            return ResponseBody.fromString(
              jsonEncode({
                'access_token': 'rotated-access',
                'expires_in': 28800,
                'refresh_token': 'rotated-refresh',
                'refresh_token_expires_in': 15897600,
              }),
              200,
              headers: {
                Headers.contentTypeHeader: [Headers.jsonContentType],
              },
            );
          }

          expect(options.headers['Authorization'], 'Bearer rotated-access');
          return ResponseBody.fromString(
            jsonEncode({'ok': true}),
            200,
            headers: {
              Headers.contentTypeHeader: [Headers.jsonContentType],
            },
          );
        });
      final apiClient = ApiClient(dio: dio, storageService: storage);

      final response = await apiClient.dio.get('/user');

      expect(response.data, {'ok': true});
      expect(storage.session?.accessToken, 'rotated-access');
      expect(storage.session?.refreshToken, 'rotated-refresh');
    },
  );

  test('ApiClient refreshes after one 401 and retries request once', () async {
    final storage = FakeSecureStorageService(
      session: buildSession(
        accessToken: 'stale-access',
        accessTokenExpiresAt: DateTime.utc(2026, 4, 24, 20),
        refreshToken: 'refresh-token',
        refreshTokenExpiresAt: DateTime.utc(2026, 5, 24, 10),
      ),
    );
    var userRequestCount = 0;
    final dio = Dio(BaseOptions(baseUrl: 'https://api.github.com'))
      ..httpClientAdapter = StubAdapter((options) async {
        if (options.uri.host == 'github.com') {
          return ResponseBody.fromString(
            jsonEncode({
              'access_token': 'rotated-access',
              'expires_in': 28800,
              'refresh_token': 'rotated-refresh',
              'refresh_token_expires_in': 15897600,
            }),
            200,
            headers: {
              Headers.contentTypeHeader: [Headers.jsonContentType],
            },
          );
        }

        userRequestCount += 1;
        if (userRequestCount == 1) {
          return ResponseBody.fromString(
            jsonEncode({'message': 'Bad credentials'}),
            401,
            headers: {
              Headers.contentTypeHeader: [Headers.jsonContentType],
            },
          );
        }

        expect(options.headers['Authorization'], 'Bearer rotated-access');
        return ResponseBody.fromString(
          jsonEncode({'ok': true}),
          200,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      });
    final apiClient = ApiClient(dio: dio, storageService: storage);

    final response = await apiClient.dio.get('/user');

    expect(response.data, {'ok': true});
    expect(userRequestCount, 2);
    expect(storage.session?.accessToken, 'rotated-access');
  });

  test('ApiClient clears session when refresh token is invalid', () async {
    final storage = FakeSecureStorageService(
      session: buildSession(
        accessToken: 'expired-access',
        accessTokenExpiresAt: DateTime.utc(2026, 4, 24, 8),
        refreshToken: 'expired-refresh',
        refreshTokenExpiresAt: DateTime.utc(2026, 5, 24, 10),
      ),
    );
    final dio = Dio(BaseOptions(baseUrl: 'https://api.github.com'))
      ..httpClientAdapter = StubAdapter((options) async {
        if (options.uri.host == 'github.com') {
          return ResponseBody.fromString(
            jsonEncode({'error': 'invalid_grant'}),
            400,
            headers: {
              Headers.contentTypeHeader: [Headers.jsonContentType],
            },
          );
        }

        return ResponseBody.fromString(
          jsonEncode({'message': 'Bad credentials'}),
          401,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      });
    final apiClient = ApiClient(dio: dio, storageService: storage);

    await expectLater(apiClient.dio.get('/user'), throwsA(isA<DioException>()));
    expect(storage.session, isNull);
  });
}
