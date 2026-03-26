import 'package:flutter/material.dart';
import 'package:flutter_github/services/storage/secure_storage_service.dart';

class LocaleProvider extends ChangeNotifier {
  LocaleProvider({SecureStorageService? storageService})
    : _storageService = storageService ?? SecureStorageService();

  static const supportedLocales = <Locale>[Locale('en'), Locale('zh')];

  final SecureStorageService _storageService;

  Locale? _locale;
  Locale? get currentLocale => _locale;

  Future<void> initialize() async {
    final localeCode = await _storageService.readLocaleCode();
    if (localeCode == null || localeCode.isEmpty) {
      return;
    }

    _locale = Locale(localeCode);
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    await _storageService.writeLocaleCode(locale.languageCode);
    notifyListeners();
  }

  Future<void> useSystemLocale() async {
    _locale = null;
    await _storageService.deleteLocaleCode();
    notifyListeners();
  }
}
