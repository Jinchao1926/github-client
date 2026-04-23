import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
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
          if (!_shouldCache(options)) {
            options.extra.addAll(_disabledCacheOptions.toExtra());
          }
          handler.next(options);
        },
      ),
    );
    this.dio.interceptors.add(DioCacheInterceptor(options: _cacheOptions));

    if (this.dio.interceptors.whereType<LogInterceptor>().isEmpty) {
      this.dio.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
    }
  }

  final Dio dio;
  final TokenProvider _tokenProvider;
  final Duration cacheDuration = const Duration(minutes: 5);

  static const _baseUrl = 'https://api.github.com';
  static final MemCacheStore _cacheStore = MemCacheStore();

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

  static Future<void> clearCache() {
    return _cacheStore.clean();
  }

  bool _shouldCache(RequestOptions options) {
    return cacheDuration > Duration.zero &&
        options.method.toUpperCase() == 'GET' &&
        _shouldAttachAccessToken(options);
  }

  CacheOptions get _cacheOptions {
    return CacheOptions(
      store: _cacheStore,
      policy: CachePolicy.forceCache,
      maxStale: cacheDuration,
      keyBuilder: ({required url, headers, body}) {
        final authorization = headers?['Authorization'] ?? '';
        return '${url.toString()}::$authorization';
      },
    );
  }

  CacheOptions get _disabledCacheOptions {
    return _cacheOptions.copyWith(policy: CachePolicy.noCache);
  }
}
