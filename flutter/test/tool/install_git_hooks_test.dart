import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/install_git_hooks.dart';

void main() {
  test('pre-commit hook runs the Dart pre-commit entrypoint', () {
    expect(
      preCommitHookContent(),
      contains('dart run tool/run_pre_commit.dart'),
    );
  });

  test('writePreCommitHook creates the repo-managed hook file', () {
    final tempDir = Directory.systemTemp.createTempSync('git-hooks-test');
    addTearDown(() => tempDir.deleteSync(recursive: true));

    writePreCommitHook(repoRoot: tempDir.path);

    final hookFile = File('${tempDir.path}/.githooks/pre-commit');

    expect(hookFile.existsSync(), isTrue);
    expect(hookFile.readAsStringSync(), equals(preCommitHookContent()));
  });
}
