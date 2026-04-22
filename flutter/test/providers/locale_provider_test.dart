import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:github_client/providers/locale_provider.dart';
import 'package:github_client/services/storage/secure_storage_service.dart';

class FakeSecureStorageService extends SecureStorageService {
  String? storedLocaleCode;

  @override
  Future<void> writeLocaleCode(String localeCode) async {
    storedLocaleCode = localeCode;
  }

  @override
  Future<String?> readLocaleCode() async {
    return storedLocaleCode;
  }

  @override
  Future<void> deleteLocaleCode() async {
    storedLocaleCode = null;
  }
}

void main() {
  test('initialize restores saved locale', () async {
    final storage = FakeSecureStorageService()..storedLocaleCode = 'zh';
    final provider = LocaleProvider(storageService: storage);

    await provider.initialize();

    expect(provider.currentLocale, const Locale('zh'));
  });

  test('setLocale stores and exposes selected locale', () async {
    final storage = FakeSecureStorageService();
    final provider = LocaleProvider(storageService: storage);

    await provider.setLocale(const Locale('en'));

    expect(provider.currentLocale, const Locale('en'));
    expect(storage.storedLocaleCode, 'en');
  });

  test('useSystemLocale clears persisted locale', () async {
    final storage = FakeSecureStorageService()..storedLocaleCode = 'zh';
    final provider = LocaleProvider(storageService: storage);

    await provider.initialize();
    await provider.useSystemLocale();

    expect(provider.currentLocale, isNull);
    expect(storage.storedLocaleCode, isNull);
  });
}
