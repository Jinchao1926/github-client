import 'dart:convert';
import 'dart:io';

const _arbDirectory = 'lib/l10n';
const _templateArbFile = 'app_en.arb';

String sortArbContent(String content, {String? templateContent}) {
  _validateNoDuplicateKeys(content);

  final decoded = json.decode(content);
  if (decoded is! Map<String, dynamic>) {
    throw const FormatException('ARB content must be a JSON object.');
  }

  final templateKeys = templateContent == null
      ? null
      : _readTemplateKeys(templateContent);
  final sorted = _sortArbMap(decoded, templateKeys: templateKeys);

  return '${const JsonEncoder.withIndent('  ').convert(sorted)}\n';
}

void main(List<String> arguments) {
  final directory = Directory(_arbDirectory);
  final templateFile = File('$_arbDirectory/$_templateArbFile');

  if (!directory.existsSync()) {
    stderr.writeln('ARB directory not found: $_arbDirectory');
    exitCode = 1;
    return;
  }

  if (!templateFile.existsSync()) {
    stderr.writeln('Template ARB file not found: ${templateFile.path}');
    exitCode = 1;
    return;
  }

  final templateContent = templateFile.readAsStringSync();
  final arbFiles =
      directory
          .listSync()
          .whereType<File>()
          .where((file) => file.path.endsWith('.arb'))
          .toList()
        ..sort((left, right) => left.path.compareTo(right.path));

  for (final file in arbFiles) {
    final isTemplate = file.path.endsWith(_templateArbFile);
    final sorted = sortArbContent(
      file.readAsStringSync(),
      templateContent: isTemplate ? null : templateContent,
    );

    file.writeAsStringSync(sorted);
    stdout.writeln('Sorted ${file.path}');
  }
}

List<String> _readTemplateKeys(String content) {
  _validateNoDuplicateKeys(content);

  final decoded = json.decode(content);
  if (decoded is! Map<String, dynamic>) {
    throw const FormatException('Template ARB content must be a JSON object.');
  }

  return _sortArbMap(decoded).keys.toList();
}

Map<String, dynamic> _sortArbMap(
  Map<String, dynamic> arb, {
  List<String>? templateKeys,
}) {
  final sorted = <String, dynamic>{};
  final emitted = <String>{};

  void emitKey(String key) {
    if (!arb.containsKey(key) || emitted.contains(key)) {
      return;
    }

    sorted[key] = arb[key];
    emitted.add(key);

    if (_isResourceKey(key)) {
      final metadataKey = '@$key';
      if (arb.containsKey(metadataKey) && !emitted.contains(metadataKey)) {
        sorted[metadataKey] = arb[metadataKey];
        emitted.add(metadataKey);
      }
    }
  }

  if (templateKeys != null) {
    for (final key in templateKeys) {
      emitKey(key);
    }
  } else {
    final localeKeys = arb.keys.where(_isLocaleMetadataKey).toList()..sort();
    final resourceKeys = arb.keys.where(_isResourceKey).toList()..sort();

    for (final key in localeKeys) {
      emitKey(key);
    }
    for (final key in resourceKeys) {
      emitKey(key);
    }
  }

  final remainingKeys = arb.keys.where((key) => !emitted.contains(key)).toList()
    ..sort();

  for (final key in remainingKeys) {
    emitKey(key);
  }

  return sorted;
}

bool _isLocaleMetadataKey(String key) => key.startsWith('@@');

bool _isResourceMetadataKey(String key) =>
    key.startsWith('@') && !_isLocaleMetadataKey(key);

bool _isResourceKey(String key) =>
    !key.startsWith('@') && !_isResourceMetadataKey(key);

void _validateNoDuplicateKeys(String content) {
  final keys = _readTopLevelKeys(content);
  final seen = <String>{};

  for (final key in keys) {
    if (!seen.add(key)) {
      throw FormatException('Duplicate ARB key found: $key');
    }
  }
}

List<String> _readTopLevelKeys(String content) {
  final keys = <String>[];
  var index = 0;
  var depth = 0;
  var inString = false;
  var escaped = false;
  var expectingKey = false;

  while (index < content.length) {
    final char = content[index];

    if (inString) {
      if (escaped) {
        escaped = false;
      } else if (char == r'\') {
        escaped = true;
      } else if (char == '"') {
        inString = false;
      }
      index++;
      continue;
    }

    if (char == '"') {
      if (depth == 1 && expectingKey) {
        final result = _readJsonString(content, index);
        keys.add(result.value);
        index = result.endIndex;
        expectingKey = false;
        continue;
      }

      inString = true;
      index++;
      continue;
    }

    if (char == '{') {
      depth++;
      if (depth == 1) {
        expectingKey = true;
      }
    } else if (char == '}') {
      depth--;
      expectingKey = false;
    } else if (char == ',' && depth == 1) {
      expectingKey = true;
    }

    index++;
  }

  return keys;
}

_JsonString _readJsonString(String content, int startIndex) {
  final buffer = StringBuffer();
  var index = startIndex + 1;
  var escaped = false;

  while (index < content.length) {
    final char = content[index];

    if (escaped) {
      buffer.write('\\$char');
      escaped = false;
    } else if (char == r'\') {
      escaped = true;
    } else if (char == '"') {
      return _JsonString(json.decode('"$buffer"') as String, index + 1);
    } else {
      buffer.write(char);
    }

    index++;
  }

  throw const FormatException('Unterminated JSON string.');
}

class _JsonString {
  const _JsonString(this.value, this.endIndex);

  final String value;
  final int endIndex;
}
