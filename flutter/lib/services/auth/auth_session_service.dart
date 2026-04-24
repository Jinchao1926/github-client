import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:github_client/models/github_auth_session.dart';
import 'package:github_client/services/storage/secure_storage_service.dart';

typedef RefreshSession =
    Future<GitHubAuthSession> Function(String refreshToken);

class AuthSessionService {
  AuthSessionService({
    required SecureStorageService storageService,
    required RefreshSession refreshSession,
  }) : _storageService = storageService,
       _refreshSession = refreshSession;

  final SecureStorageService _storageService;
  final RefreshSession _refreshSession;

  static final Set<VoidCallback> _invalidationListeners = <VoidCallback>{};

  Future<GitHubAuthSession?>? _refreshFuture;

  Future<GitHubAuthSession?> readSession() {
    return _storageService.readAuthSession();
  }

  Future<String?> getValidAccessToken() async {
    final session = await _storageService.readAuthSession();
    if (session == null) {
      return _storageService.readAccessToken();
    }

    if (!session.isAccessTokenExpired) {
      return session.accessToken;
    }

    final refreshedSession = await refreshSessionToken();
    return refreshedSession?.accessToken;
  }

  Future<GitHubAuthSession?> refreshSessionToken({bool force = false}) async {
    final session = await _storageService.readAuthSession();
    if (session == null) {
      return null;
    }

    if (!force && !session.isAccessTokenExpired) {
      return session;
    }

    if (session.isRefreshTokenExpired) {
      await clearSession(notify: true);
      return null;
    }

    final currentRefresh = _refreshFuture;
    if (currentRefresh != null) {
      return currentRefresh;
    }

    final refreshFuture = _performRefresh(session);
    _refreshFuture = refreshFuture;

    try {
      return await refreshFuture;
    } finally {
      if (identical(_refreshFuture, refreshFuture)) {
        _refreshFuture = null;
      }
    }
  }

  Future<void> clearSession({bool notify = false}) async {
    await _storageService.deleteAuthSession();
    if (notify) {
      for (final listener in List<VoidCallback>.from(_invalidationListeners)) {
        listener();
      }
    }
  }

  void addInvalidationListener(VoidCallback listener) {
    _invalidationListeners.add(listener);
  }

  void removeInvalidationListener(VoidCallback listener) {
    _invalidationListeners.remove(listener);
  }

  Future<GitHubAuthSession?> _performRefresh(GitHubAuthSession session) async {
    try {
      final refreshedSession = await _refreshSession(session.refreshToken);
      await _storageService.writeAuthSession(refreshedSession);
      return refreshedSession;
    } on DioException catch (error) {
      if (_isInvalidGrant(error)) {
        await clearSession(notify: true);
        return null;
      }
      rethrow;
    } catch (error) {
      if (_isInvalidGrantError(error)) {
        await clearSession(notify: true);
        return null;
      }
      rethrow;
    }
  }

  bool _isInvalidGrant(DioException error) {
    final response = error.response;
    if (response?.statusCode != 400) {
      return false;
    }

    final data = response?.data;
    if (data is Map<String, dynamic>) {
      return data['error'] == 'invalid_grant';
    }
    return false;
  }

  bool _isInvalidGrantError(Object error) {
    return error.toString().contains('invalid_grant');
  }
}
