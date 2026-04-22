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
}
