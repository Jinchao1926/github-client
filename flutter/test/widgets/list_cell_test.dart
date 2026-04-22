import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:github_client/widgets/common/list_cell.dart';

void main() {
  testWidgets('ListCell shows detail value before chevron', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ListCell(
            title: 'Appearance',
            detail: 'Dark',
            onTap: _noop,
          ),
        ),
      ),
    );

    expect(find.text('Appearance'), findsOneWidget);
    expect(find.text('Dark'), findsOneWidget);
    expect(find.byIcon(Icons.chevron_right), findsOneWidget);
  });
}

void _noop() {}
