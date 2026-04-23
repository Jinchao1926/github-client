import 'dart:convert';
import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:github_client/services/api/api_client.dart';
import 'package:github_client/services/storage/secure_storage_service.dart';

class FakeSecureStorageService extends SecureStorageService {
  FakeSecureStorageService({this.accessToken});

  final String? accessToken;

  @override
  Future<String?> readAccessToken() async {
    return accessToken;
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

void main() {
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
        cacheDuration: const Duration(milliseconds: 30),
      );

      final firstResponse = await apiClient.dio.get('/user');
      final cachedResponse = await apiClient.dio.get('/user');
      await Future<void>.delayed(const Duration(milliseconds: 50));
      final refreshedResponse = await apiClient.dio.get('/user');

      expect(firstResponse.data, {'count': 1});
      expect(cachedResponse.data, {'count': 1});
      expect(refreshedResponse.data, {'count': 2});
      expect(adapter.requestCount, 2);
    },
  );
}
