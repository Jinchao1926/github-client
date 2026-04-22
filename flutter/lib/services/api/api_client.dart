import 'package:dio/dio.dart';
import 'package:github_client/services/storage/secure_storage_service.dart';

typedef TokenProvider = Future<String?> Function();

class ApiClient {
  ApiClient({
    Dio? dio,
    SecureStorageService? storageService,
    TokenProvider? tokenProvider,
  }) : _tokenProvider =
           tokenProvider ??
           (storageService ?? SecureStorageService()).readAccessToken,
       dio = dio ?? Dio(_createBaseOptions()) {
    this.dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (_shouldAttachAccessToken(options)) {
            final token = await _tokenProvider.call();
            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }
          handler.next(options);
        },
      ),
    );

    if (this.dio.interceptors.whereType<LogInterceptor>().isEmpty) {
      this.dio.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
    }
  }

  final Dio dio;
  final TokenProvider _tokenProvider;

  static const _baseUrl = 'https://api.github.com';

  static BaseOptions _createBaseOptions() {
    const timeout = Duration(seconds: 15);
    return BaseOptions(
      baseUrl: _baseUrl,
      headers: {'Accept': 'application/vnd.github+json'},
      connectTimeout: timeout,
      receiveTimeout: timeout,
      sendTimeout: timeout,
    );
  }

  static bool _shouldAttachAccessToken(RequestOptions options) {
    return options.uri.host == Uri.parse(_baseUrl).host;
  }
}
