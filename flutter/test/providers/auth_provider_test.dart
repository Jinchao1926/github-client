import 'package:flutter_test/flutter_test.dart';
import 'package:github_client/models/github_auth_session.dart';
import 'package:github_client/models/github_user.dart';
import 'package:github_client/providers/auth_provider.dart';
import 'package:github_client/services/auth/auth_session_service.dart';
import 'package:github_client/services/auth/github_oauth_service.dart';
import 'package:github_client/services/storage/secure_storage_service.dart';

class FakeGitHubOAuthService extends GitHubOAuthService {
  FakeGitHubOAuthService({this.sessionToReturn, this.userToReturn, this.error});

  final GitHubAuthSession? sessionToReturn;
  final GitHubUser? userToReturn;
  final Object? error;

  @override
  Future<GitHubAuthSession> signIn() async {
    if (error != null) throw error!;
    return sessionToReturn!;
  }

  @override
  Future<GitHubUser> fetchCurrentUser() async {
    if (error != null) throw error!;
    return userToReturn!;
  }
}

class FakeSecureStorageService extends SecureStorageService {
  FakeSecureStorageService({this.initialSession});

  GitHubAuthSession? initialSession;
  GitHubAuthSession? storedSession;
  String? storedLocaleCode;

  @override
  Future<void> writeAuthSession(GitHubAuthSession session) async {
    storedSession = session;
  }

  @override
  Future<GitHubAuthSession?> readAuthSession() async {
    return storedSession ?? initialSession;
  }

  @override
  Future<void> deleteAuthSession() async {
    storedSession = null;
    initialSession = null;
  }

  @override
  Future<void> writeLocaleCode(String localeCode) async {
    storedLocaleCode = localeCode;
  }

  @override
  Future<String?> readLocaleCode() async {
    return storedLocaleCode;
  }

  @override
  Future<void> deleteLocaleCode() async {
    storedLocaleCode = null;
  }
}

void main() {
  final session = GitHubAuthSession(
    accessToken: 'token',
    accessTokenExpiresAt: DateTime.utc(2026, 4, 24, 12),
    refreshToken: 'refresh-token',
    refreshTokenExpiresAt: DateTime.utc(2026, 5, 24, 12),
  );
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

  test('initialize restores user from stored session', () async {
    final provider = AuthProvider(
      authService: FakeGitHubOAuthService(userToReturn: user),
      storageService: FakeSecureStorageService(initialSession: session),
    );

    await provider.initialize();

    expect(provider.isAuthenticated, isTrue);
    expect(provider.user?.login, 'octocat');
  });

  test('signIn stores full session and user on success', () async {
    final storage = FakeSecureStorageService();
    final provider = AuthProvider(
      authService: FakeGitHubOAuthService(
        sessionToReturn: session,
        userToReturn: user,
      ),
      storageService: storage,
    );

    await provider.signIn();

    expect(provider.isAuthenticated, isTrue);
    expect(provider.user?.login, 'octocat');
    expect(storage.storedSession, session);
  });

  test('signOut clears user and token', () async {
    final storage = FakeSecureStorageService();
    var didClearApiCache = false;
    final provider = AuthProvider(
      authService: FakeGitHubOAuthService(
        sessionToReturn: session,
        userToReturn: user,
      ),
      storageService: storage,
      clearApiCache: () async {
        didClearApiCache = true;
      },
    );

    await provider.signIn();
    await provider.signOut();

    expect(provider.isAuthenticated, isFalse);
    expect(provider.user, isNull);
    expect(storage.storedSession, isNull);
    expect(didClearApiCache, isTrue);
  });

  test('provider signs out when session service invalidates auth', () async {
    final storage = FakeSecureStorageService(initialSession: session);
    final authSessionService = AuthSessionService(
      storageService: storage,
      refreshSession: (_) async => session,
    );
    final provider = AuthProvider(
      authService: FakeGitHubOAuthService(userToReturn: user),
      storageService: storage,
      authSessionService: authSessionService,
    );

    await provider.initialize();
    await authSessionService.clearSession(notify: true);

    expect(provider.isAuthenticated, isFalse);
    expect(provider.user, isNull);
    expect(storage.storedSession, isNull);
  });
}
