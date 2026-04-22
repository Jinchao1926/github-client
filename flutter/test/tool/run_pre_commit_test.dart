import 'package:flutter_test/flutter_test.dart';

import '../../tool/run_pre_commit.dart';

void main() {
  test('detects explicit fix mode', () {
    expect(shouldFixArbFiles(['--fix']), isTrue);
    expect(shouldFixArbFiles(const []), isFalse);
  });

  test('detects staged arb files under lib/l10n', () {
    expect(
      hasStagedArbChanges([
        'lib/l10n/app_en.arb',
        'lib/pages/home/home_page.dart',
      ]),
      isTrue,
    );
  });

  test('ignores non-arb staged files', () {
    expect(
      hasStagedArbChanges(['lib/pages/home/home_page.dart', 'README.md']),
      isFalse,
    );
  });

  test('reports unsorted template arb files', () {
    final unsortedFiles = findUnsortedArbFiles({
      'lib/l10n/app_en.arb': '''
{
  "zebra": "Zebra",
  "@@locale": "en",
  "apple": "Apple"
}
''',
      'lib/l10n/app_zh.arb': '''
{
  "@@locale": "zh",
  "apple": "苹果",
  "zebra": "斑马"
}
''',
    });

    expect(unsortedFiles, ['lib/l10n/app_en.arb']);
  });

  test('reports unsorted translated arb files against template order', () {
    final unsortedFiles = findUnsortedArbFiles({
      'lib/l10n/app_en.arb': '''
{
  "@@locale": "en",
  "apple": "Apple",
  "zebra": "Zebra"
}
''',
      'lib/l10n/app_zh.arb': '''
{
  "@@locale": "zh",
  "zebra": "斑马",
  "apple": "苹果"
}
''',
    });

    expect(unsortedFiles, ['lib/l10n/app_zh.arb']);
  });

  test('builds sorted arb contents for fix mode', () {
    final sortedContents = buildSortedArbContents({
      'lib/l10n/app_en.arb': '''
{
  "zebra": "Zebra",
  "@@locale": "en",
  "apple": "Apple"
}
''',
      'lib/l10n/app_zh.arb': '''
{
  "zebra": "斑马",
  "@@locale": "zh",
  "apple": "苹果"
}
''',
    });

    expect(
      sortedContents['lib/l10n/app_en.arb']!,
      contains('"@@locale": "en"'),
    );
    expect(
      sortedContents['lib/l10n/app_en.arb']!.indexOf('"apple"'),
      lessThan(sortedContents['lib/l10n/app_en.arb']!.indexOf('"zebra"')),
    );
    expect(
      sortedContents['lib/l10n/app_zh.arb']!.indexOf('"apple"'),
      lessThan(sortedContents['lib/l10n/app_zh.arb']!.indexOf('"zebra"')),
    );
  });

  test('builds actionable error message for unsorted arb files', () {
    final message = buildUnsortedArbMessage([
      'lib/l10n/app_en.arb',
      'lib/l10n/app_zh.arb',
    ]);

    expect(message, contains('ARB files are not sorted'));
    expect(message, contains('lib/l10n/app_en.arb'));
    expect(message, contains('lib/l10n/app_zh.arb'));
    expect(message, contains('rps l10n:sort'));
    expect(message, contains('--fix'));
  });
}
