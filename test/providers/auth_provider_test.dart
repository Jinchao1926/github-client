import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_github/models/github_user.dart';
import 'package:flutter_github/providers/auth_provider.dart';
import 'package:flutter_github/services/auth/github_oauth_service.dart';
import 'package:flutter_github/services/storage/secure_storage_service.dart';

class FakeGitHubOAuthService extends GitHubOAuthService {
  FakeGitHubOAuthService({this.tokenToReturn, this.userToReturn, this.error});

  final String? tokenToReturn;
  final GitHubUser? userToReturn;
  final Object? error;

  @override
  Future<String> signIn() async {
    if (error != null) throw error!;
    return tokenToReturn!;
  }

  @override
  Future<GitHubUser> fetchCurrentUser(String accessToken) async {
    if (error != null) throw error!;
    return userToReturn!;
  }
}

class FakeSecureStorageService extends SecureStorageService {
  FakeSecureStorageService({this.initialToken});

  String? initialToken;
  String? storedToken;

  @override
  Future<void> writeAccessToken(String token) async {
    storedToken = token;
  }

  @override
  Future<String?> readAccessToken() async {
    return storedToken ?? initialToken;
  }

  @override
  Future<void> deleteAccessToken() async {
    storedToken = null;
    initialToken = null;
  }
}

void main() {
  const user = GitHubUser(
    login: 'octocat',
    name: 'The Octocat',
    avatarUrl: '',
    bio: 'Mascot',
  );

  test('initialize keeps signed-out state when no token exists', () async {
    final provider = AuthProvider(
      authService: FakeGitHubOAuthService(userToReturn: user),
      storageService: FakeSecureStorageService(),
    );

    await provider.initialize();

    expect(provider.isAuthenticated, isFalse);
    expect(provider.user, isNull);
  });

  test('signIn stores token and user on success', () async {
    final storage = FakeSecureStorageService();
    final provider = AuthProvider(
      authService: FakeGitHubOAuthService(tokenToReturn: 'token', userToReturn: user),
      storageService: storage,
    );

    await provider.signIn();

    expect(provider.isAuthenticated, isTrue);
    expect(provider.user?.login, 'octocat');
    expect(storage.storedToken, 'token');
  });

  test('signOut clears user and token', () async {
    final storage = FakeSecureStorageService();
    final provider = AuthProvider(
      authService: FakeGitHubOAuthService(tokenToReturn: 'token', userToReturn: user),
      storageService: storage,
    );

    await provider.signIn();
    await provider.signOut();

    expect(provider.isAuthenticated, isFalse);
    expect(provider.user, isNull);
    expect(storage.storedToken, isNull);
  });
}
