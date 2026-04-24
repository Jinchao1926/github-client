import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:github_client/models/github_user.dart';
import 'package:github_client/services/api/api_client.dart';
import 'package:github_client/services/auth/auth_session_service.dart';
import 'package:github_client/services/auth/github_oauth_service.dart';
import 'package:github_client/services/storage/secure_storage_service.dart';

typedef ClearApiCache = Future<void> Function();

class AuthProvider extends ChangeNotifier {
  factory AuthProvider({
    GitHubOAuthService? authService,
    SecureStorageService? storageService,
    AuthSessionService? authSessionService,
    ClearApiCache? clearApiCache,
  }) {
    final resolvedStorageService = storageService ?? SecureStorageService();
    final refreshAuthService = authService ?? GitHubOAuthService();
    final resolvedAuthSessionService =
        authSessionService ??
        AuthSessionService(
          storageService: resolvedStorageService,
          refreshSession: (refreshToken) =>
              refreshAuthService.refreshSession(refreshToken),
        );
    final resolvedAuthService =
        authService ??
        GitHubOAuthService(
          apiClient: ApiClient(
            storageService: resolvedStorageService,
            authSessionService: resolvedAuthSessionService,
          ),
        );

    return AuthProvider._(
      resolvedStorageService,
      resolvedAuthService,
      resolvedAuthSessionService,
      clearApiCache ?? ApiClient.clearCache,
    );
  }

  AuthProvider._(
    SecureStorageService storageService,
    GitHubOAuthService authService,
    AuthSessionService authSessionService,
    ClearApiCache clearApiCache,
  ) : _storageService = storageService,
      _clearApiCache = clearApiCache,
      _authSessionService = authSessionService,
      _authService = authService {
    _authSessionService.addInvalidationListener(_handleSessionInvalidated);
  }

  final GitHubOAuthService _authService;
  final SecureStorageService _storageService;
  final AuthSessionService _authSessionService;
  final ClearApiCache _clearApiCache;

  bool _isInitializing = false;
  bool _isSigningIn = false;
  GitHubUser? _user;
  String? _errorMessage;

  bool get isInitializing => _isInitializing;
  bool get isSigningIn => _isSigningIn;
  bool get isAuthenticated => _user != null;
  GitHubUser? get user => _user;
  String? get errorMessage => _errorMessage;

  Future<void> initialize() async {
    _isInitializing = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final session = await _storageService.readAuthSession();
      if (session == null) {
        _user = null;
        return;
      }

      _user = await _authService.fetchCurrentUser();
    } catch (_) {
      await _storageService.deleteAuthSession();
      _user = null;
    } finally {
      _isInitializing = false;
      notifyListeners();
    }
  }

  Future<void> signIn() async {
    _isSigningIn = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final session = await _authService.signIn();
      await _storageService.writeAuthSession(session);
      _user = await _authService.fetchCurrentUser();
    } catch (error) {
      _user = null;
      _errorMessage = error.toString().replaceFirst('Exception: ', '');
    } finally {
      _isSigningIn = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _authSessionService.clearSession();
    await _clearApiCache();
    _user = null;
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _authSessionService.removeInvalidationListener(_handleSessionInvalidated);
    super.dispose();
  }

  void _handleSessionInvalidated() {
    _user = null;
    _errorMessage = null;
    unawaited(_clearApiCache());
    notifyListeners();
  }
}
