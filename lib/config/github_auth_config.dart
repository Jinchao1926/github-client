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
