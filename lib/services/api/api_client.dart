import 'package:dio/dio.dart';

typedef TokenProvider = Future<String?> Function();

class ApiClient {
  ApiClient({Dio? dio, TokenProvider? tokenProvider})
    : _tokenProvider = tokenProvider,
      dio = dio ?? Dio(_createBaseOptions()) {
    this.dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _tokenProvider?.call();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
            this.dio.options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );

    if (this.dio.interceptors.whereType<LogInterceptor>().isEmpty) {
      this.dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
        ),
      );
    }
  }

  final Dio dio;
  final TokenProvider? _tokenProvider;

  static BaseOptions _createBaseOptions() {
    const timeout = Duration(seconds: 15);
    return BaseOptions(
      baseUrl: 'https://api.github.com',
      headers: {'Accept': 'application/vnd.github+json'},
      connectTimeout: timeout,
      receiveTimeout: timeout,
      sendTimeout: timeout,
    );
  }
}
