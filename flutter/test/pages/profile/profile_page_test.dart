import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:github_client/l10n/app_localizations.dart';
import 'package:github_client/models/github_auth_session.dart';
import 'package:github_client/models/github_user.dart';
import 'package:github_client/pages/profile/profile_page.dart';
import 'package:github_client/providers/auth_provider.dart';
import 'package:github_client/providers/locale_provider.dart';
import 'package:github_client/services/auth/github_oauth_service.dart';
import 'package:github_client/services/storage/secure_storage_service.dart';
import 'package:github_client/themes/index.dart';

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
  GitHubAuthSession? storedSession;
  String? storedLocaleCode;

  @override
  Future<void> writeAuthSession(GitHubAuthSession session) async {
    storedSession = session;
  }

  @override
  Future<GitHubAuthSession?> readAuthSession() async {
    return storedSession;
  }

  @override
  Future<void> deleteAuthSession() async {
    storedSession = null;
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

Widget buildTestApp(AuthProvider provider) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ChangeNotifierProvider(create: (_) => LocaleProvider()),
      ChangeNotifierProvider<AuthProvider>.value(value: provider),
    ],
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: LocaleProvider.supportedLocales,
      home: const ProfilePage(),
    ),
  );
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

  testWidgets('ProfilePage shows user info when signed in', (
    WidgetTester tester,
  ) async {
    final provider = AuthProvider(
      authService: FakeGitHubOAuthService(
        sessionToReturn: session,
        userToReturn: user,
      ),
      storageService: FakeSecureStorageService(),
    );

    await provider.signIn();
    await tester.pumpWidget(buildTestApp(provider));

    expect(find.text('octocat'), findsOneWidget);
    expect(find.text('The Octocat'), findsOneWidget);
    expect(find.text('Sign out'), findsOneWidget);
    expect(find.text('Sign in with GitHub'), findsNothing);
  });
}
