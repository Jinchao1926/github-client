import 'package:flutter_dotenv/flutter_dotenv.dart';

class GitHubAuthConfig {
  // https://github.com/settings/apps/jinchaohub

  /*
   * By launch.json
  static const clientId = String.fromEnvironment('GITHUB_CLIENT_ID');
  static const clientSecret = String.fromEnvironment('GITHUB_CLIENT_SECRET');
  static const callbackScheme = String.fromEnvironment(
    'GITHUB_CALLBACK_SCHEME',
    defaultValue: 'jinchaohub',
  );
  static const callbackHost = String.fromEnvironment(
    'GITHUB_CALLBACK_HOST',
    defaultValue: 'oauth-callback',
  );
  */

  static String get clientId =>
      dotenv.isInitialized ? (dotenv.maybeGet('GITHUB_CLIENT_ID') ?? '') : '';
  static String get clientSecret => dotenv.isInitialized
      ? (dotenv.maybeGet('GITHUB_CLIENT_SECRET') ?? '')
      : '';
  static String get callbackScheme => dotenv.isInitialized
      ? dotenv.maybeGet('GITHUB_CALLBACK_SCHEME', fallback: 'jinchaohub')!
      : 'jinchaohub';
  static String get callbackHost => dotenv.isInitialized
      ? dotenv.maybeGet('GITHUB_CALLBACK_HOST', fallback: 'oauth-callback')!
      : 'oauth-callback';
  static const authorizationEndpoint =
      'https://github.com/login/oauth/authorize';
  static const tokenEndpoint = 'https://github.com/login/oauth/access_token';
  // static const scopes = <String>['user', 'repo'];

  static String get redirectUri => '$callbackScheme://$callbackHost';
}
