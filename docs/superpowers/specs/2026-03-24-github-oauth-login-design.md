# GitHub OAuth Login Design

- Date: 2026-03-24
- Topic: GitHub OAuth login for Flutter GitHub client
- Status: Approved for planning

## Goal

Add GitHub sign-in to this Flutter client so that users can authenticate with a GitHub OAuth App, keep their access token in secure local storage, automatically restore their session on app launch, and see their GitHub profile information on the Profile page.

## Scope

This design covers the first working login slice for:

- iOS
- Android

This version includes:

- GitHub OAuth App login
- PKCE-based authorization flow
- secure local token storage
- restore session on startup
- fetching the authenticated GitHub user
- rendering signed-in state in `ProfilePage`
- sign out

This version does not include:

- server-side token exchange
- macOS or web login support
- repository, notifications, or inbox data sync after login
- broader API client refactors beyond what this flow needs

## Existing Project Context

Current app structure is simple and UI-focused:

- `lib/main.dart` creates `MaterialApp` and currently wires only `ThemeProvider`
- `lib/pages/profile/profile_page.dart` currently shows a placeholder profile screen and already has a settings entry point
- `lib/pages/settings/settings_page.dart` contains static settings rows
- `lib/pages/routes/app_routes.dart` manages named routes
- `pubspec.yaml` currently includes only `provider` beyond Flutter defaults

There is no existing authentication, network, token storage, or user model layer.

## Chosen Approach

Use a GitHub OAuth App with PKCE in the Flutter client.

### Why this approach

- matches the desired user-facing login experience
- avoids using a personal access token input flow
- is safer than embedding `client_secret` in the mobile app
- fits a mobile-only first version without requiring a backend immediately
- can later evolve to a backend-assisted exchange behind the same auth abstraction

## Alternatives Considered

### 1. OAuth App + PKCE in client (chosen)
Pros:
- best fit for mobile client login
- no `client_secret` embedded in app
- complete end-to-end user experience in first version

Cons:
- requires redirect/deep link setup on iOS and Android
- adds auth state and callback handling to app lifecycle

### 2. OAuth App with direct client-side token exchange using `client_secret`
Pros:
- simplest implementation shape in a pure client app

Cons:
- unsafe for a distributed mobile client
- bakes sensitive credentials into the app bundle

### 3. Backend-assisted OAuth exchange
Pros:
- strongest security boundary
- better long-term architecture if app backend exists

Cons:
- requires new backend work
- larger scope than needed for this first version

## Architecture

Add a dedicated authentication slice, kept separate from theming, routing, and business pages.

### Components

#### `lib/config/github_auth_config.dart`
Stores GitHub OAuth configuration needed by the app:

- `clientId`
- redirect URI or redirect scheme details
- OAuth scopes
- authorization endpoint
- token endpoint
- user endpoint

This keeps auth-specific constants out of widgets and providers.

#### `lib/models/github_user.dart`
Represents the authenticated GitHub user returned by `/user`.

Expected fields for v1:

- `login`
- `name`
- `avatarUrl`
- optional `bio`

It should include JSON parsing and be small enough to reuse later for other profile surfaces.

#### `lib/services/storage/secure_storage_service.dart`
Wraps secure device persistence.

Responsibilities:

- store access token
- read stored access token
- delete access token

This isolates storage implementation details from the auth flow.

#### `lib/services/auth/github_oauth_service.dart`
Handles the GitHub auth flow and authenticated user fetch.

Responsibilities:

- generate PKCE verifier and challenge
- generate and validate OAuth state
- build authorization URL
- launch browser-based auth flow via callback-capable auth package
- exchange authorization code for access token
- request current user from GitHub `/user`

This service should expose a clean interface so token exchange can later move to a backend without changing UI code.

#### `lib/providers/auth_provider.dart`
Owns auth state for the app.

State for v1:

- initialization/loading state
- login-in-progress state
- current authenticated user
- authenticated vs unauthenticated state
- latest user-visible error message

Responsibilities:

- initialize from secure storage on app launch
- trigger sign in
- trigger sign out
- load authenticated user
- clear invalid stored credentials
- notify listening widgets when auth state changes

#### `lib/pages/profile/profile_page.dart`
Acts as the first auth surface.

Responsibilities:

- show signed-out login prompt
- show loading state during login
- show GitHub user information when signed in
- show sign-out action
- preserve existing settings navigation

No dedicated login page is required for v1.

## UI and Navigation Design

### Signed-out state
`ProfilePage` shows a login card or section with:

- GitHub-branded sign-in action
- short explanatory text that signing in connects the user account

This keeps the login entry point close to where authenticated identity is displayed.

### Signing-in state
While sign-in is in progress:

- disable repeated taps
- show inline loading state on button or section
- keep user on `ProfilePage`

### Signed-in state
`ProfilePage` should display:

- avatar
- display name
- login/username
- optional bio if available
- sign-out button

The existing settings action in the app bar remains unchanged.

### Startup restoration
On app startup:

1. `AuthProvider` loads stored token from secure storage
2. if no token exists, state remains signed out
3. if token exists, provider requests `/user`
4. if `/user` succeeds, state becomes signed in
5. if `/user` fails due to invalid or expired token, token is cleared and state returns to signed out

## Data Flow

### Sign in flow
1. User taps `Sign in with GitHub` on `ProfilePage`
2. `AuthProvider.signIn()` begins login and sets loading state
3. `GitHubOAuthService` generates PKCE values and `state`
4. Service opens GitHub authorization URL in system browser
5. User authenticates and approves access
6. GitHub redirects back to app via configured callback
7. Service validates returned `state`
8. Service exchanges authorization `code` plus `codeVerifier` for access token
9. `SecureStorageService` persists the token
10. Service fetches `/user`
11. `AuthProvider` stores resulting `GitHubUser`
12. `ProfilePage` rebuilds into signed-in UI

### Restore session flow
1. App starts
2. `AuthProvider.initialize()` reads token
3. If token exists, service fetches `/user`
4. Success restores signed-in state
5. Failure removes token and falls back to signed-out state

### Sign out flow
1. User taps `Sign out`
2. `AuthProvider.signOut()` clears secure storage
3. Provider clears in-memory user and auth state
4. `ProfilePage` rebuilds into signed-out UI

## Error Handling

Keep error handling minimal and user-visible.

### Cases
- user cancels browser auth: show a short cancellation message and return to signed-out state
- callback `state` mismatch: treat as failed login and do not persist anything
- token exchange failure: show a short login failure message
- `/user` request failure immediately after login: treat login as failed and leave app signed out
- `/user` request failure during restore: clear stored token and silently or minimally return to signed-out state
- network failure: show a brief error message and stop loading

### Non-goals
Do not add complex retry systems, analytics events, or fallback auth paths in v1.

## Security Considerations

- Use PKCE for the OAuth authorization code flow
- Do not embed or rely on a GitHub `client_secret` in the mobile app
- Persist access token only in secure platform storage
- Validate OAuth `state` before exchanging code
- Keep token handling inside service/storage layers, not widgets
- Make the token exchange path replaceable so a backend-assisted flow can be introduced later

## Platform Requirements

### iOS
- register redirect URL scheme for app callback
- ensure chosen auth package can return control to app after browser authorization

### Android
- register matching intent filter / callback scheme
- ensure callback URI matches GitHub OAuth App configuration exactly

## Dependencies

Expected packages for v1:

- `provider` (already present)
- `flutter_secure_storage`
- `flutter_web_auth_2` or equivalent browser auth callback package
- `http`
- `crypto`

Final package choice can be validated during implementation planning, but the architecture assumes:

- secure storage package for token persistence
- browser auth callback package for OAuth redirect handling
- basic HTTP client for GitHub API calls
- crypto support for PKCE challenge generation

## Testing Strategy

### Unit tests
- `GitHubUser` JSON parsing
- PKCE helper generation/transform logic
- `AuthProvider` state transitions for initialize, sign in success/failure, and sign out

### Widget tests
- `ProfilePage` shows sign-in UI when signed out
- `ProfilePage` shows user details when signed in

### Manual verification
- first-time login on iOS and Android
- app relaunch restores session
- sign out clears session
- invalid stored token returns app to signed-out state

## Implementation Boundaries

To keep v1 small and reliable:

- do not redesign the app navigation structure
- do not add a dedicated auth feature area unless implementation pressure demands it
- do not fetch broader GitHub business data after login
- do not refactor unrelated settings or home code
- keep the first authenticated surface limited to `ProfilePage`

## Recommended Next Step

Create an implementation plan that adds the auth configuration, service, provider, secure storage, callback handling, and `ProfilePage` UI updates in small verifiable steps.
