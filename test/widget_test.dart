import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:flutter_github/main.dart';
import 'package:flutter_github/providers/auth_provider.dart';
import 'package:flutter_github/themes/index.dart';

void main() {
  testWidgets('app boots to home page', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => AuthProvider()),
        ],
        child: const MyApp(),
      ),
    );

    expect(find.text('Home'), findsWidgets);
    expect(find.text('Search Github'), findsOneWidget);
  });
}
