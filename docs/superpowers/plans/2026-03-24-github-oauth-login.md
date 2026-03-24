# GitHub OAuth Login Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add GitHub OAuth App login with PKCE, secure local token storage, session restore on startup, and signed-in Profile UI for iOS and Android.

**Architecture:** Add a small authentication slice centered on `AuthProvider`, `GitHubOAuthService`, and `SecureStorageService`. Keep the first authenticated UI limited to `ProfilePage`, wire provider initialization in `main.dart`, and support callback-based OAuth without introducing unrelated app-wide refactors.

**Tech Stack:** Flutter, provider, http, crypto, flutter_secure_storage, flutter_web_auth_2, flutter_test

---

## File Map

### Create
- `lib/config/github_auth_config.dart` — GitHub OAuth constants and configuration helpers
- `lib/models/github_user.dart` — authenticated user model and JSON parsing
- `lib/services/storage/secure_storage_service.dart` — secure token persistence wrapper
- `lib/services/auth/github_oauth_service.dart` — PKCE generation, OAuth browser flow, token exchange, current-user fetch
- `lib/providers/auth_provider.dart` — app auth state and public login/logout/initialize methods
- `test/models/github_user_test.dart` — user model parsing tests
- `test/providers/auth_provider_test.dart` — auth provider state tests with fakes
- `test/pages/profile/profile_page_test.dart` — Profile page signed-out and signed-in widget tests

### Modify
- `pubspec.yaml` — add auth/network/storage dependencies
- `lib/main.dart` — register `AuthProvider`, trigger initialization, keep existing theme provider
- `lib/pages/profile/profile_page.dart` — render login state, loading state, user data, and sign-out action
- `test/widget_test.dart` — replace broken counter smoke test with a minimal app smoke test or remove if superseded by focused tests
- `android/app/src/main/AndroidManifest.xml` — register auth callback intent filter if required by chosen package
- `ios/Runner/Info.plist` — register callback URL scheme for OAuth redirect

### Notes for implementer
- Keep token exchange behind `GitHubOAuthService`; do not leak token handling into widgets.
- Keep package-specific auth callback handling inside service/config, not spread through UI.
- Do not add a dedicated login page in this plan.
- Do not fetch repositories, notifications, or other post-login business data.

## Task 1: Add dependencies and auth configuration scaffold

**Files:**
- Modify: `pubspec.yaml`
- Create: `lib/config/github_auth_config.dart`
- Test: none

- [ ] **Step 1: Add the required dependencies to `pubspec.yaml`**

Add these packages under `dependencies`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  provider: ^6.1.5
  flutter_secure_storage: ^9.2.4
  flutter_web_auth_2: ^4.1.0
  http: ^1.5.0
  crypto: ^3.0.6
```

- [ ] **Step 2: Fetch packages**

Run: `flutter pub get`
Expected: dependency resolution succeeds and `pubspec.lock` updates.

- [ ] **Step 3: Create `lib/config/github_auth_config.dart`**

Add minimal config constants and helpers:

```dart
class GitHubAuthConfig {
  static const clientId = String.fromEnvironment('GITHUB_CLIENT_ID');
  static const callbackScheme = 'fluttergithub';
  static const callbackHost = 'auth';
  static const authorizationEndpoint = 'https://github.com/login/oauth/authorize';
  static const tokenEndpoint = 'https://github.com/login/oauth/access_token';
  static const userEndpoint = 'https://api.github.com/user';
  static const scopes = <String>['read:user', 'user:email'];

  static String get redirectUri => '$callbackScheme://$callbackHost';
}
```

- [ ] **Step 4: Verify no code references are broken yet**

Run: `flutter analyze`
Expected: it may still fail on later planned missing files, but `pubspec.yaml` parses and config file is accepted.

- [ ] **Step 5: Commit**

```bash
git add pubspec.yaml pubspec.lock lib/config/github_auth_config.dart
git commit -m "feat: add github auth dependencies and config scaffold"
```

## Task 2: Add the GitHub user model with tests

**Files:**
- Create: `lib/models/github_user.dart`
- Test: `test/models/github_user_test.dart`

- [ ] **Step 1: Write the failing model test**

Create `test/models/github_user_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_github/models/github_user.dart';

void main() {
  test('GitHubUser.fromJson parses expected fields', () {
    final user = GitHubUser.fromJson(const {
      'login': 'octocat',
      'name': 'The Octocat',
      'avatar_url': 'https://example.com/avatar.png',
      'bio': 'Mascot',
    });

    expect(user.login, 'octocat');
    expect(user.name, 'The Octocat');
    expect(user.avatarUrl, 'https://example.com/avatar.png');
    expect(user.bio, 'Mascot');
  });
}
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `flutter test test/models/github_user_test.dart`
Expected: FAIL because `GitHubUser` does not exist yet.

- [ ] **Step 3: Write the minimal model implementation**

Create `lib/models/github_user.dart`:

```dart
class GitHubUser {
  const GitHubUser({
    required this.login,
    required this.name,
    required this.avatarUrl,
    required this.bio,
  });

  final String login;
  final String? name;
  final String avatarUrl;
  final String? bio;

  factory GitHubUser.fromJson(Map<String, dynamic> json) {
    return GitHubUser(
      login: json['login'] as String,
      name: json['name'] as String?,
      avatarUrl: json['avatar_url'] as String,
      bio: json['bio'] as String?,
    );
  }
}
```

- [ ] **Step 4: Re-run the test**

Run: `flutter test test/models/github_user_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/models/github_user.dart test/models/github_user_test.dart
git commit -m "feat: add github user model"
```

## Task 3: Add secure storage service

**Files:**
- Create: `lib/services/storage/secure_storage_service.dart`
- Test: none in this task

- [ ] **Step 1: Create the storage wrapper**

Create `lib/services/storage/secure_storage_service.dart`:

```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  SecureStorageService({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  static const accessTokenKey = 'github_access_token';

  final FlutterSecureStorage _storage;

  Future<void> writeAccessToken(String token) {
    return _storage.write(key: accessTokenKey, value: token);
  }

  Future<String?> readAccessToken() {
    return _storage.read(key: accessTokenKey);
  }

  Future<void> deleteAccessToken() {
    return _storage.delete(key: accessTokenKey);
  }
}
```

- [ ] **Step 2: Run analysis for the new file**

Run: `flutter analyze`
Expected: no issues from the storage service itself.

- [ ] **Step 3: Commit**

```bash
git add lib/services/storage/secure_storage_service.dart
git commit -m "feat: add secure token storage service"
```

## Task 4: Build PKCE and GitHub OAuth service with focused tests for pure logic

**Files:**
- Create: `lib/services/auth/github_oauth_service.dart`
- Test: extend `test/models/github_user_test.dart` only if needed for helpers, otherwise defer OAuth flow testing to provider/service integration by fakes

- [ ] **Step 1: Add a pure helper test for PKCE output shape**

If keeping helper methods public or `@visibleForTesting`, add a small test file:

`test/services/auth/github_oauth_service_test.dart`

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_github/services/auth/github_oauth_service.dart';

void main() {
  test('createCodeChallenge returns URL-safe non-empty string', () {
    const verifier = 'plain-text-code-verifier-1234567890';

    final challenge = GitHubOAuthService.createCodeChallenge(verifier);

    expect(challenge, isNotEmpty);
    expect(challenge.contains('+'), isFalse);
    expect(challenge.contains('/'), isFalse);
    expect(challenge.contains('='), isFalse);
  });
}
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `flutter test test/services/auth/github_oauth_service_test.dart`
Expected: FAIL because the service does not exist yet.

- [ ] **Step 3: Implement the minimal `GitHubOAuthService`**

Create a service with:

- static `createCodeVerifier()`
- static `createCodeChallenge(String verifier)`
- static `createState()`
- `Future<String> signIn()` to run OAuth and return access token
- `Future<GitHubUser> fetchCurrentUser(String accessToken)`

Implementation details:

```dart
import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_github/config/github_auth_config.dart';
import 'package:flutter_github/models/github_user.dart';

class GitHubOAuthService {
  GitHubOAuthService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static String createCodeVerifier() { /* random URL-safe string */ }
  static String createState() { /* random URL-safe string */ }
  static String createCodeChallenge(String verifier) { /* sha256 + base64Url without padding */ }

  Future<String> signIn() async {
    // build authorize url with client_id, redirect_uri, scope, state,
    // code_challenge, code_challenge_method=S256
    // call FlutterWebAuth2.authenticate
    // parse callback uri, validate state, read code
    // POST token request with Accept: application/json
    // return access_token
  }

  Future<GitHubUser> fetchCurrentUser(String accessToken) async {
    final response = await _client.get(
      Uri.parse(GitHubAuthConfig.userEndpoint),
      headers: {
        'Accept': 'application/vnd.github+json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load GitHub user');
    }

    return GitHubUser.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }
}
```

Keep cancellation, missing code, missing token, and state mismatch as thrown exceptions with short messages.

- [ ] **Step 4: Re-run the PKCE helper test**

Run: `flutter test test/services/auth/github_oauth_service_test.dart`
Expected: PASS.

- [ ] **Step 5: Run analysis**

Run: `flutter analyze`
Expected: service compiles, though app is not wired yet.

- [ ] **Step 6: Commit**

```bash
git add lib/services/auth/github_oauth_service.dart test/services/auth/github_oauth_service_test.dart
git commit -m "feat: add github oauth service"
```

## Task 5: Add `AuthProvider` with state tests

**Files:**
- Create: `lib/providers/auth_provider.dart`
- Create: `test/providers/auth_provider_test.dart`

- [ ] **Step 1: Write the failing provider tests**

Create `test/providers/auth_provider_test.dart` with fake service and fake storage. Cover these cases:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_github/models/github_user.dart';
import 'package:flutter_github/providers/auth_provider.dart';

void main() {
  test('initialize keeps signed-out state when no token exists', () async {
    final provider = AuthProvider(
      authService: FakeGitHubOAuthService(),
      storageService: FakeSecureStorageService(),
    );

    await provider.initialize();

    expect(provider.isAuthenticated, isFalse);
    expect(provider.user, isNull);
  });

  test('signIn stores token and user on success', () async {
    final provider = AuthProvider(
      authService: FakeGitHubOAuthService(
        tokenToReturn: 'token',
        userToReturn: const GitHubUser(
          login: 'octocat',
          name: 'The Octocat',
          avatarUrl: 'https://example.com/avatar.png',
          bio: 'Mascot',
        ),
      ),
      storageService: FakeSecureStorageService(),
    );

    await provider.signIn();

    expect(provider.isAuthenticated, isTrue);
    expect(provider.user?.login, 'octocat');
  });

  test('signOut clears user and token', () async {
    // arrange signed-in provider, call signOut, assert cleared state
  });
}
```

- [ ] **Step 2: Run the provider tests to verify they fail**

Run: `flutter test test/providers/auth_provider_test.dart`
Expected: FAIL because provider does not exist yet.

- [ ] **Step 3: Implement the minimal provider**

Create `lib/providers/auth_provider.dart` with:

```dart
import 'package:flutter/foundation.dart';
import 'package:flutter_github/models/github_user.dart';
import 'package:flutter_github/services/auth/github_oauth_service.dart';
import 'package:flutter_github/services/storage/secure_storage_service.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider({
    GitHubOAuthService? authService,
    SecureStorageService? storageService,
  }) : _authService = authService ?? GitHubOAuthService(),
       _storageService = storageService ?? SecureStorageService();

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

  Future<void> initialize() async { /* read token, fetch user, clear invalid token on failure */ }
  Future<void> signIn() async { /* sign in, persist token, fetch user, expose errors */ }
  Future<void> signOut() async { /* clear token and user */ }
}
```

Implementation rules:
- clear stale `errorMessage` before fresh actions
- call `notifyListeners()` on each visible state transition
- if initialize restore fails, delete token and end signed out
- if sign-in fails, leave provider signed out and store a short message

- [ ] **Step 4: Re-run provider tests**

Run: `flutter test test/providers/auth_provider_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/providers/auth_provider.dart test/providers/auth_provider_test.dart
git commit -m "feat: add auth provider"
```

## Task 6: Wire `AuthProvider` into app startup

**Files:**
- Modify: `lib/main.dart`
- Test: reuse provider tests; no new test required in this task

- [ ] **Step 1: Replace the single-provider app root with `MultiProvider`**

Update `lib/main.dart` so it provides:
- `ThemeProvider`
- `AuthProvider`

Suggested shape:

```dart
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()..initialize()),
      ],
      child: const MyApp(),
    ),
  );
}
```

- [ ] **Step 2: Run focused tests to ensure the app still boots in tests**

Run: `flutter test test/providers/auth_provider_test.dart test/models/github_user_test.dart`
Expected: PASS.

- [ ] **Step 3: Run analysis**

Run: `flutter analyze`
Expected: no provider wiring errors.

- [ ] **Step 4: Commit**

```bash
git add lib/main.dart
git commit -m "feat: wire auth provider into app startup"
```

## Task 7: Update `ProfilePage` to render auth states

**Files:**
- Modify: `lib/pages/profile/profile_page.dart`
- Create: `test/pages/profile/profile_page_test.dart`

- [ ] **Step 1: Write the signed-out widget test**

Add test coverage for the logged-out state:

```dart
testWidgets('ProfilePage shows GitHub sign-in action when signed out', (
  WidgetTester tester,
) async {
  await tester.pumpWidget(
    ChangeNotifierProvider<AuthProvider>.value(
      value: fakeSignedOutProvider,
      child: const MaterialApp(home: ProfilePage()),
    ),
  );

  expect(find.text('Sign in with GitHub'), findsOneWidget);
});
```

- [ ] **Step 2: Add the signed-in widget test**

```dart
testWidgets('ProfilePage shows user info when signed in', (
  WidgetTester tester,
) async {
  await tester.pumpWidget(
    ChangeNotifierProvider<AuthProvider>.value(
      value: fakeSignedInProvider,
      child: const MaterialApp(home: ProfilePage()),
    ),
  );

  expect(find.text('octocat'), findsOneWidget);
  expect(find.text('The Octocat'), findsOneWidget);
  expect(find.text('Sign out'), findsOneWidget);
});
```

- [ ] **Step 3: Run the widget test to verify it fails**

Run: `flutter test test/pages/profile/profile_page_test.dart`
Expected: FAIL because `ProfilePage` still shows placeholder content.

- [ ] **Step 4: Implement the minimal `ProfilePage` auth UI**

Update `lib/pages/profile/profile_page.dart` to:
- read `AuthProvider` with `context.watch<AuthProvider>()`
- keep the existing app bar and settings action
- render one of three bodies:
  - initializing/signing in: centered progress indicator or disabled loading button
  - signed out: login section with `Sign in with GitHub`
  - signed in: avatar, display name fallback, login, optional bio, `Sign out`
- use `ScaffoldMessenger` or inline text for `errorMessage`, but keep it simple

Minimal signed-in section shape:

```dart
Column(
  mainAxisSize: MainAxisSize.min,
  children: [
    CircleAvatar(radius: 32, backgroundImage: NetworkImage(user.avatarUrl)),
    const SizedBox(height: 12),
    Text(user.name ?? user.login),
    Text('@${user.login}'),
    if (user.bio != null) Text(user.bio!),
    const SizedBox(height: 16),
    OutlinedButton(onPressed: provider.signOut, child: const Text('Sign out')),
  ],
)
```

- [ ] **Step 5: Re-run the widget tests**

Run: `flutter test test/pages/profile/profile_page_test.dart`
Expected: PASS.

- [ ] **Step 6: Commit**

```bash
git add lib/pages/profile/profile_page.dart test/pages/profile/profile_page_test.dart
git commit -m "feat: add profile auth states"
```

## Task 8: Configure iOS and Android OAuth callback plumbing

**Files:**
- Modify: `ios/Runner/Info.plist`
- Modify: `android/app/src/main/AndroidManifest.xml`
- Test: manual verification only

- [ ] **Step 1: Read current callback-related platform config before editing**

Run:
- `plutil -p ios/Runner/Info.plist`
- inspect `android/app/src/main/AndroidManifest.xml`

Expected: confirm where URL scheme and intent filter entries belong.

- [ ] **Step 2: Register iOS callback scheme**

Add a URL type using the configured scheme, for example:

```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>fluttergithub</string>
    </array>
  </dict>
</array>
```

- [ ] **Step 3: Register Android callback handling if required by the chosen package**

Add the package-required `<intent-filter>` to the main activity, matching the callback scheme and host:

```xml
<intent-filter android:label="github_auth">
  <action android:name="android.intent.action.VIEW" />
  <category android:name="android.intent.category.DEFAULT" />
  <category android:name="android.intent.category.BROWSABLE" />
  <data android:scheme="fluttergithub" android:host="auth" />
</intent-filter>
```

- [ ] **Step 4: Run analysis and platform sanity checks**

Run: `flutter analyze`
Expected: Dart code still passes. Platform files remain syntactically valid.

- [ ] **Step 5: Commit**

```bash
git add ios/Runner/Info.plist android/app/src/main/AndroidManifest.xml
git commit -m "feat: add github oauth callback configuration"
```

## Task 9: Replace the default widget smoke test with app-relevant coverage

**Files:**
- Modify: `test/widget_test.dart`

- [ ] **Step 1: Replace the counter test with a minimal app smoke test**

Update `test/widget_test.dart` to assert the app builds and shows bottom navigation labels:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_github/main.dart';

void main() {
  testWidgets('app boots with primary tabs visible', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Inbox'), findsOneWidget);
    expect(find.text('Explore'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });
}
```

If direct `MyApp()` construction now requires providers above it, either wrap the app in the same providers used in production or move the smoke test to `MainTabPage`.

- [ ] **Step 2: Run the smoke test**

Run: `flutter test test/widget_test.dart`
Expected: PASS.

- [ ] **Step 3: Commit**

```bash
git add test/widget_test.dart
git commit -m "test: replace default flutter smoke test"
```

## Task 10: Run full verification and document manual setup

**Files:**
- Modify: `docs/superpowers/plans/2026-03-24-github-oauth-login.md` (check off completed steps during execution only)
- Test: all relevant files above

- [ ] **Step 1: Run targeted test suite**

Run:
```bash
flutter test \
  test/models/github_user_test.dart \
  test/services/auth/github_oauth_service_test.dart \
  test/providers/auth_provider_test.dart \
  test/pages/profile/profile_page_test.dart \
  test/widget_test.dart
```
Expected: PASS.

- [ ] **Step 2: Run static analysis**

Run: `flutter analyze`
Expected: PASS.

- [ ] **Step 3: Run manual mobile verification**

Run on iOS simulator/device and Android emulator/device with `--dart-define=GITHUB_CLIENT_ID=...`.

Manual checklist:
- app launches normally
- `Profile` shows sign-in button when signed out
- tapping sign-in opens GitHub auth in browser
- successful auth returns to app
- `Profile` shows avatar, name/login, optional bio
- relaunch restores signed-in state
- sign out clears signed-in state
- invalid token case returns to signed-out state

- [ ] **Step 4: Record any required GitHub OAuth App settings for the human operator**

Confirm these values are configured in the GitHub OAuth App:
- callback URL matching the app callback (for example `fluttergithub://auth` if GitHub accepts that callback configuration in your setup)
- mobile app `clientId`
- requested scopes for v1

If GitHub OAuth App callback rules require a different redirect shape for mobile, adjust `GitHubAuthConfig` and platform config consistently before release.

- [ ] **Step 5: Commit**

```bash
git add lib pubspec.yaml pubspec.lock test ios/Runner/Info.plist android/app/src/main/AndroidManifest.xml
git commit -m "feat: add github oauth login"
```

## Risks and checks before implementation

- `flutter_web_auth_2` callback requirements must match the final Android/iOS native configuration exactly.
- GitHub OAuth App support details for PKCE and callback URI format should be verified against current GitHub behavior before implementing the token exchange details.
- `MyApp` currently assumes providers are above it; tests may need explicit provider wrappers if constructing `MyApp` directly.
- Keep tests focused on pure logic and widget states; do not try to run real OAuth flows inside unit/widget tests.

## Execution notes

- Implement tasks in order.
- Keep each commit scoped to one task.
- Request review after each task if using `@superpowers:subagent-driven-development`.
- Do not skip the failing-test-first steps where tests are specified.
