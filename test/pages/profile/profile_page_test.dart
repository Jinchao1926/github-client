import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:flutter_github/models/github_user.dart';
import 'package:flutter_github/pages/profile/profile_page.dart';
import 'package:flutter_github/providers/auth_provider.dart';
import 'package:flutter_github/services/auth/github_oauth_service.dart';
import 'package:flutter_github/services/storage/secure_storage_service.dart';
import 'package:flutter_github/themes/index.dart';

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
  Future<GitHubUser> fetchCurrentUser() async {
    if (error != null) throw error!;
    return userToReturn!;
  }
}

class FakeSecureStorageService extends SecureStorageService {
  String? storedToken;

  @override
  Future<void> writeAccessToken(String token) async {
    storedToken = token;
  }

  @override
  Future<String?> readAccessToken() async {
    return storedToken;
  }

  @override
  Future<void> deleteAccessToken() async {
    storedToken = null;
  }
}

Widget buildTestApp(AuthProvider provider) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ChangeNotifierProvider<AuthProvider>.value(value: provider),
    ],
    child: const MaterialApp(home: ProfilePage()),
  );
}

void main() {
  const user = GitHubUser(
    login: 'octocat',
    name: 'The Octocat',
    avatarUrl: '',
    bio: 'Mascot',
  );

  testWidgets('ProfilePage shows GitHub sign-in action when signed out', (
    WidgetTester tester,
  ) async {
    final provider = AuthProvider(
      authService: FakeGitHubOAuthService(userToReturn: user),
      storageService: FakeSecureStorageService(),
    );

    await tester.pumpWidget(buildTestApp(provider));

    expect(find.text('Sign in with GitHub'), findsOneWidget);
  });

  testWidgets('ProfilePage shows user info when signed in', (
    WidgetTester tester,
  ) async {
    final provider = AuthProvider(
      authService: FakeGitHubOAuthService(tokenToReturn: 'token', userToReturn: user),
      storageService: FakeSecureStorageService(),
    );

    await provider.signIn();
    await tester.pumpWidget(buildTestApp(provider));

    expect(find.text('octocat'), findsOneWidget);
    expect(find.text('The Octocat'), findsOneWidget);
    expect(find.text('Sign out'), findsOneWidget);
  });
}
