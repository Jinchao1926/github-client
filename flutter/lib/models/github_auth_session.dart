class GitHubAuthSession {
  const GitHubAuthSession({
    required this.accessToken,
    required this.accessTokenExpiresAt,
    required this.refreshToken,
    required this.refreshTokenExpiresAt,
  });

  factory GitHubAuthSession.fromTokenResponse(
    Map<String, dynamic> json, {
    DateTime? now,
  }) {
    final currentTime = (now ?? DateTime.now()).toUtc();
    final accessToken = json['access_token'] as String?;
    final expiresIn = json['expires_in'] as int?;
    final refreshToken = json['refresh_token'] as String?;
    final refreshTokenExpiresIn = json['refresh_token_expires_in'] as int?;

    if (accessToken == null || accessToken.isEmpty) {
      throw Exception('Missing access token');
    }
    if (expiresIn == null || expiresIn <= 0) {
      throw Exception('Missing access token expiry');
    }
    if (refreshToken == null || refreshToken.isEmpty) {
      throw Exception('Missing refresh token');
    }
    if (refreshTokenExpiresIn == null || refreshTokenExpiresIn <= 0) {
      throw Exception('Missing refresh token expiry');
    }

    return GitHubAuthSession(
      accessToken: accessToken,
      accessTokenExpiresAt: currentTime.add(Duration(seconds: expiresIn)),
      refreshToken: refreshToken,
      refreshTokenExpiresAt: currentTime.add(
        Duration(seconds: refreshTokenExpiresIn),
      ),
    );
  }

  final String accessToken;
  final DateTime accessTokenExpiresAt;
  final String refreshToken;
  final DateTime refreshTokenExpiresAt;

  bool get isAccessTokenExpired =>
      !accessTokenExpiresAt.isAfter(DateTime.now().toUtc());

  bool get isRefreshTokenExpired =>
      !refreshTokenExpiresAt.isAfter(DateTime.now().toUtc());

  Map<String, String> toStorageMap() {
    return {
      'access_token': accessToken,
      'access_token_expires_at': accessTokenExpiresAt.toIso8601String(),
      'refresh_token': refreshToken,
      'refresh_token_expires_at': refreshTokenExpiresAt.toIso8601String(),
    };
  }

  factory GitHubAuthSession.fromStorageMap(Map<String, String> values) {
    final accessToken = values['access_token'];
    final accessTokenExpiresAt = values['access_token_expires_at'];
    final refreshToken = values['refresh_token'];
    final refreshTokenExpiresAt = values['refresh_token_expires_at'];

    if (accessToken == null ||
        accessTokenExpiresAt == null ||
        refreshToken == null ||
        refreshTokenExpiresAt == null) {
      throw Exception('Incomplete auth session');
    }

    return GitHubAuthSession(
      accessToken: accessToken,
      accessTokenExpiresAt: DateTime.parse(accessTokenExpiresAt).toUtc(),
      refreshToken: refreshToken,
      refreshTokenExpiresAt: DateTime.parse(refreshTokenExpiresAt).toUtc(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GitHubAuthSession &&
        other.accessToken == accessToken &&
        other.accessTokenExpiresAt == accessTokenExpiresAt &&
        other.refreshToken == refreshToken &&
        other.refreshTokenExpiresAt == refreshTokenExpiresAt;
  }

  @override
  int get hashCode => Object.hash(
    accessToken,
    accessTokenExpiresAt,
    refreshToken,
    refreshTokenExpiresAt,
  );
}
