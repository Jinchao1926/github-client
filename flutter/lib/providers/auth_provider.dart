import 'package:flutter/foundation.dart';

import 'package:github_client/models/github_user.dart';
import 'package:github_client/services/api/api_client.dart';
import 'package:github_client/services/auth/github_oauth_service.dart';
import 'package:github_client/services/storage/secure_storage_service.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider({
    GitHubOAuthService? authService,
    SecureStorageService? storageService,
  }) : this._(storageService ?? SecureStorageService(), authService);

  AuthProvider._(
    SecureStorageService storageService,
    GitHubOAuthService? authService,
  ) : _storageService = storageService,
      _authService =
          authService ??
          GitHubOAuthService(
            apiClient: ApiClient(storageService: storageService),
          );

  final GitHubOAuthService _authService;
  final SecureStorageService _storageService;

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
      final token = await _storageService.readAccessToken();
      if (token == null || token.isEmpty) {
        _user = null;
        return;
      }

      _user = await _authService.fetchCurrentUser();
    } catch (_) {
      await _storageService.deleteAccessToken();
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
      final token = await _authService.signIn();
      await _storageService.writeAccessToken(token);
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
    await _storageService.deleteAccessToken();
    _user = null;
    _errorMessage = null;
    notifyListeners();
  }
}
