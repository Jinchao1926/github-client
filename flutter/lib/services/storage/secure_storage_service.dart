import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  SecureStorageService({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  static const accessTokenKey = 'github_access_token';
  static const localeCodeKey = 'app_locale_code';

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
