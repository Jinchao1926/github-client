import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:github_client/main.dart';
import 'package:github_client/providers/auth_provider.dart';
import 'package:github_client/providers/locale_provider.dart';
import 'package:github_client/services/storage/secure_storage_service.dart';
import 'package:github_client/themes/index.dart';

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
  testWidgets('app boots to login page when signed out', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ],
        child: const MyApp(),
      ),
    );

    expect(find.text('Sign in with GitHub'), findsOneWidget);
    expect(find.text('Home'), findsNothing);
  });

  testWidgets('app renders chinese locale when selected', (
    WidgetTester tester,
  ) async {
    final localeProvider = LocaleProvider(
      storageService: FakeSecureStorageService(),
    );
    await localeProvider.setLocale(const Locale('zh'));

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider<LocaleProvider>.value(value: localeProvider),
        ],
        child: const MyApp(),
      ),
    );

    expect(find.text('使用 GitHub 登录'), findsOneWidget);
    expect(find.text('首页'), findsNothing);
  });
}
