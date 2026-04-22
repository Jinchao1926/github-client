# GitHub Client

A Flutter GitHub client project.

## 1. Tech Stack

- `provider`: state management
- `dio`: HTTP networking
- `flutter_secure_storage`: secure local storage for sensitive data
- `flutter_web_auth_2`: GitHub OAuth login flow
- `flutter_dotenv`: loads environment variables from `.env`
- `json_annotation` / `json_serializable` / `build_runner`: JSON serialization code generation
- `flutter_localizations`: localization support

## 2. Getting Started

Install dependencies:

```sh
flutter pub get
```

Run on the current selected device:

```sh
flutter run
```

Run on a specific device:

```sh
flutter devices
flutter run -d <device-id>
```

## 3. Code Generation

This project uses:

- `mason`: generate model scaffolds
- `rps`: run `build_runner`

### 3.1 Install Tools

```sh
dart pub global activate mason_cli
dart pub global activate rps
```

If needed, add Dart global bin to `PATH`:

```sh
export PATH="$PATH:$HOME/.pub-cache/bin"
```

### 3.2 Sync Local Brick

This repo provides a local brick named `json_model`.

```sh
mason get
```

### 3.3 Create a Model

```sh
mason make json_model
```

Example values:

- `class_name`: `GithubOrganization`
- `file_name`: `github_organization`

Generated file:

- `lib/models/github_organization.dart`

### 3.4 Generate `.g.dart`

```sh
rps build
```

Or watch continuously:

```sh
rps watch
```

Typical workflow:

```sh
mason get
mason make json_model
rps build
```

## 4. Environment Configuration

The app loads the root `.env` file on startup.

Use the following format:

```env
GITHUB_CLIENT_ID=your_client_id
GITHUB_CLIENT_SECRET=your_client_secret
GITHUB_CALLBACK_SCHEME=jinchaohub
GITHUB_CALLBACK_HOST=oauth-callback
```

Variables:

- `GITHUB_CLIENT_ID`: GitHub OAuth App Client ID
- `GITHUB_CLIENT_SECRET`: GitHub OAuth App Client Secret
- `GITHUB_CALLBACK_SCHEME`: OAuth callback scheme
- `GITHUB_CALLBACK_HOST`: OAuth callback host

The redirect URI format used by this project is:

```text
{GITHUB_CALLBACK_SCHEME}://{GITHUB_CALLBACK_HOST}
```

Example:

```text
jinchaohub://oauth-callback
```

Make sure the callback scheme also matches the iOS URL scheme configured in
`ios/Runner/Info.plist`.

## 5. iOS Simulator Startup

If macOS runs successfully but the iOS Simulator stays at `Launching...`, the
Flutter SDK may be missing the current iOS engine artifacts.

Flutter has three relevant layers:

- Flutter framework: the Dart APIs used by app code.
- Flutter tool: commands such as `flutter run` and `flutter build`.
- Flutter engine: the native runtime used for rendering, Dart execution,
  platform channels, and platform embedding.

Each Flutter SDK version points to a specific engine revision. The SDK stores
downloaded platform artifacts under its local cache. If the iOS cache still
contains artifacts for an older engine revision, `flutter run` needs to download
the matching iOS artifacts before it can build and launch the simulator app.
When that download is slow, blocked, or interrupted, startup can appear stuck at
`Launching...`.

Pre-download the required iOS artifacts with:

```sh
flutter precache --ios
```

To pre-download artifacts for all enabled platforms, run:

```sh
flutter precache
```

Useful cache locations:

- `<flutter-sdk>/bin/cache/engine.stamp`: the engine revision expected by the
  current Flutter SDK.
- `<flutter-sdk>/bin/cache/ios-sdk.stamp`: the iOS artifact revision currently
  cached locally.
- `<flutter-sdk>/bin/cache/artifacts/engine/ios`: cached iOS engine artifacts.
- `<flutter-sdk>/bin/cache/downloads`: downloaded artifact archives.

After refreshing the cache, run the simulator again:

```sh
flutter run -d <ios-simulator-id>
```
