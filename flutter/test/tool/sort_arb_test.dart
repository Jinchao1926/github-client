import 'package:flutter_test/flutter_test.dart';

import '../../tool/sort_arb.dart';

void main() {
  test(
    'sorts template keys alphabetically while keeping metadata adjacent',
    () {
      const source = '''
{
  "zebra": "Zebra",
  "apple": "Apple",
  "@apple": {
    "description": "Fruit"
  },
  "@@locale": "en"
}
''';

      final sorted = sortArbContent(source);

      expect(sorted.indexOf('"@@locale"'), lessThan(sorted.indexOf('"apple"')));
      expect(sorted.indexOf('"apple"'), lessThan(sorted.indexOf('"@apple"')));
      expect(sorted.indexOf('"@apple"'), lessThan(sorted.indexOf('"zebra"')));
    },
  );

  test('sorts translated keys by template order', () {
    const template = '''
{
  "@@locale": "en",
  "apple": "Apple",
  "zebra": "Zebra"
}
''';
    const translation = '''
{
  "zebra": "斑马",
  "@@locale": "zh",
  "apple": "苹果"
}
''';

    final sorted = sortArbContent(translation, templateContent: template);

    expect(sorted.indexOf('"@@locale"'), lessThan(sorted.indexOf('"apple"')));
    expect(sorted.indexOf('"apple"'), lessThan(sorted.indexOf('"zebra"')));
  });

  test('throws when duplicate keys are present', () {
    const source = '''
{
  "@@locale": "en",
  "apple": "Apple",
  "apple": "Duplicate apple"
}
''';

    expect(() => sortArbContent(source), throwsA(isA<FormatException>()));
  });
}
