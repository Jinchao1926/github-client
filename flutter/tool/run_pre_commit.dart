import 'dart:io';

import 'sort_arb.dart';

bool shouldFixArbFiles(List<String> arguments) => arguments.contains('--fix');

bool hasStagedArbChanges(Iterable<String> paths) {
  return paths.any(
    (path) => path.startsWith('lib/l10n/') && path.endsWith('.arb'),
  );
}

Map<String, String> buildSortedArbContents(Map<String, String> arbContents) {
  final sortedPaths = arbContents.keys.toList()..sort();
  final templatePath = sortedPaths.firstWhere(
    (path) => path.endsWith('app_en.arb'),
    orElse: () => '',
  );
  final templateContent = templatePath.isEmpty
      ? null
      : arbContents[templatePath];

  return {
    for (final path in sortedPaths)
      path: sortArbContent(
        arbContents[path]!,
        templateContent: path == templatePath ? null : templateContent,
      ),
  };
}

List<String> findUnsortedArbFiles(Map<String, String> arbContents) {
  final sortedContents = buildSortedArbContents(arbContents);
  final unsortedFiles = <String>[];

  for (final path in sortedContents.keys) {
    if (arbContents[path] != sortedContents[path]) {
      unsortedFiles.add(path);
    }
  }

  return unsortedFiles;
}

String buildUnsortedArbMessage(List<String> unsortedFiles) {
  final fileList = unsortedFiles.map((path) => '- $path').join('\n');
  return [
    'ARB files are not sorted:',
    fileList,
    'Run `rps l10n:sort` or `dart run tool/run_pre_commit.dart --fix`, then re-stage the updated files.',
  ].join('\n');
}

void main(List<String> arguments) {
  final arbContents = _readArbContents();
  final unsortedFiles = findUnsortedArbFiles(arbContents);
  if (unsortedFiles.isEmpty) {
    return;
  }

  if (shouldFixArbFiles(arguments)) {
    final sortedContents = buildSortedArbContents(arbContents);
    for (final path in unsortedFiles) {
      File(path).writeAsStringSync(sortedContents[path]!);
      stdout.writeln('Sorted $path');
    }
    return;
  }

  stderr.writeln(buildUnsortedArbMessage(unsortedFiles));
  exitCode = 1;
}

Map<String, String> _readArbContents() {
  final l10nDirectory = Directory('lib/l10n');
  if (!l10nDirectory.existsSync()) {
    return const {};
  }

  final arbFiles =
      l10nDirectory
          .listSync()
          .whereType<File>()
          .where((file) => file.path.endsWith('.arb'))
          .toList()
        ..sort((left, right) => left.path.compareTo(right.path));

  return {for (final file in arbFiles) file.path: file.readAsStringSync()};
}
