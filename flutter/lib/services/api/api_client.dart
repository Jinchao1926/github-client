import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:github_client/services/auth/auth_session_service.dart';
import 'package:github_client/services/auth/github_oauth_service.dart';
import 'package:github_client/services/storage/secure_storage_service.dart';

typedef TokenProvider = Future<String?> Function();

class ApiClient {
  ApiClient({
    Dio? dio,
    SecureStorageService? storageService,
    TokenProvider? tokenProvider,
    AuthSessionService? authSessionService,
    Duration? cacheDuration,
  }) : _storageService = storageService ?? SecureStorageService(),
       _tokenProvider = tokenProvider,
       _useSessionService = authSessionService != null || tokenProvider == null,
       cacheDuration = cacheDuration ?? const Duration(minutes: 5),
       dio = dio ?? Dio(_createBaseOptions()) {
    _authSessionService =
        authSessionService ??
        AuthSessionService(
          storageService: _storageService,
          refreshSession: (refreshToken) =>
              GitHubOAuthService(apiClient: this).refreshSession(refreshToken),
        );
    this.dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (_shouldAttachAccessToken(options)) {
            final token = await _getAccessToken();
            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }
          if (!_shouldCache(options)) {
            options.extra.addAll(_disabledCacheOptions.toExtra());
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          if (!_shouldRetryWithRefresh(error)) {
            handler.next(error);
            return;
          }

          try {
            final refreshedSession = await _authSessionService
                .refreshSessionToken(force: true);
            final refreshedToken = refreshedSession?.accessToken;
            if (refreshedToken == null || refreshedToken.isEmpty) {
              handler.next(error);
              return;
            }

            final response = await _retryRequest(
              error.requestOptions,
              refreshedToken,
            );
            handler.resolve(response);
          } on DioException catch (retryError) {
            handler.next(retryError);
          } catch (_) {
            handler.next(error);
          }
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
  final SecureStorageService _storageService;
  final TokenProvider? _tokenProvider;
  final bool _useSessionService;
  late final AuthSessionService _authSessionService;
  final Duration cacheDuration;

  static const _baseUrl = 'https://api.github.com';
  static const _retriedAuthKey = 'auth_retry_attempted';
  static final MemCacheStore _cacheStore = MemCacheStore();

  static BaseOptions _createBaseOptions() {
    const timeout = Duration(seconds: 30);
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

  Future<String?> _getAccessToken() async {
    if (_useSessionService) {
      return _authSessionService.getValidAccessToken();
    }
    return _tokenProvider?.call();
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

  bool _shouldRetryWithRefresh(DioException error) {
    if (!_useSessionService) {
      return false;
    }

    final requestOptions = error.requestOptions;
    final statusCode = error.response?.statusCode;
    if (!_shouldAttachAccessToken(requestOptions)) {
      return false;
    }
    if (requestOptions.extra[_retriedAuthKey] == true) {
      return false;
    }

    return statusCode == 401;
  }

  Future<Response<dynamic>> _retryRequest(
    RequestOptions requestOptions,
    String accessToken,
  ) {
    final headers = Map<String, dynamic>.from(requestOptions.headers);
    headers['Authorization'] = 'Bearer $accessToken';

    final extra = Map<String, dynamic>.from(requestOptions.extra);
    extra[_retriedAuthKey] = true;

    return dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      cancelToken: requestOptions.cancelToken,
      options: Options(
        method: requestOptions.method,
        headers: headers,
        responseType: requestOptions.responseType,
        contentType: requestOptions.contentType,
        validateStatus: requestOptions.validateStatus,
        receiveDataWhenStatusError: requestOptions.receiveDataWhenStatusError,
        followRedirects: requestOptions.followRedirects,
        sendTimeout: requestOptions.sendTimeout,
        receiveTimeout: requestOptions.receiveTimeout,
        extra: extra,
      ),
    );
  }
}
