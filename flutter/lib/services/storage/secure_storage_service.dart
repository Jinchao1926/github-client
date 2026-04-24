import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:github_client/models/github_auth_session.dart';

class SecureStorageService {
  SecureStorageService({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  static const accessTokenKey = 'github_access_token';
  static const accessTokenExpiresAtKey = 'github_access_token_expires_at';
  static const refreshTokenKey = 'github_refresh_token';
  static const refreshTokenExpiresAtKey = 'github_refresh_token_expires_at';
  static const localeCodeKey = 'app_locale_code';

  final FlutterSecureStorage _storage;

  Future<void> writeAccessToken(String token) {
    return _storage.write(key: accessTokenKey, value: token);
  }

  Future<String?> readAccessToken() async {
    final session = await readAuthSession();
    if (session != null) {
      return session.accessToken;
    }
    return _storage.read(key: accessTokenKey);
  }

  Future<void> deleteAccessToken() async {
    await _storage.delete(key: accessTokenKey);
  }

  Future<void> writeAuthSession(GitHubAuthSession session) async {
    final values = session.toStorageMap();
    await _storage.write(key: accessTokenKey, value: values['access_token']);
    await _storage.write(
      key: accessTokenExpiresAtKey,
      value: values['access_token_expires_at'],
    );
    await _storage.write(key: refreshTokenKey, value: values['refresh_token']);
    await _storage.write(
      key: refreshTokenExpiresAtKey,
      value: values['refresh_token_expires_at'],
    );
  }

  Future<GitHubAuthSession?> readAuthSession() async {
    final accessToken = await _storage.read(key: accessTokenKey);
    final accessTokenExpiresAt = await _storage.read(
      key: accessTokenExpiresAtKey,
    );
    final refreshToken = await _storage.read(key: refreshTokenKey);
    final refreshTokenExpiresAt = await _storage.read(
      key: refreshTokenExpiresAtKey,
    );

    if (accessToken == null ||
        accessTokenExpiresAt == null ||
        refreshToken == null ||
        refreshTokenExpiresAt == null) {
      return null;
    }

    return GitHubAuthSession.fromStorageMap({
      'access_token': accessToken,
      'access_token_expires_at': accessTokenExpiresAt,
      'refresh_token': refreshToken,
      'refresh_token_expires_at': refreshTokenExpiresAt,
    });
  }

  Future<void> deleteAuthSession() async {
    await _storage.delete(key: accessTokenKey);
    await _storage.delete(key: accessTokenExpiresAtKey);
    await _storage.delete(key: refreshTokenKey);
    await _storage.delete(key: refreshTokenExpiresAtKey);
  }

  Future<void> writeLocaleCode(String localeCode) {
    return _storage.write(key: localeCodeKey, value: localeCode);
  }

  Future<String?> readLocaleCode() {
    return _storage.read(key: localeCodeKey);
  }

  Future<void> deleteLocaleCode() {
    return _storage.delete(key: localeCodeKey);
  }
}
