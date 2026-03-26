# flutter_github

A Flutter github client project.

## Libraries

- `provider`: state management
- `dio`: HTTP networking
- `flutter_secure_storage`: secure local storage for sensitive data
- `flutter_web_auth_2`: GitHub OAuth login flow
- `flutter_dotenv`: loads environment variables from `.env`
- `json_annotation` / `json_serializable` / `build_runner`: JSON serialization code generation
- `flutter_localizations`: localization support

## `.env` Configuration

The app loads the root `.env` file on startup. Related code is in [lib/main.dart](/Users/jinchao/Develop/Github-Jinchao/flutter_github/lib/main.dart) and [lib/config/github_auth_config.dart](/Users/jinchao/Develop/Github-Jinchao/flutter_github/lib/config/github_auth_config.dart).

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
