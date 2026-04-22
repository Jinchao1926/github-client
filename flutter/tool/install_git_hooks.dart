import 'dart:io';

const hooksDirectory = '.githooks';
const preCommitHookPath = '$hooksDirectory/pre-commit';

String preCommitHookContent() => '''
#!/usr/bin/env bash
set -euo pipefail

dart run tool/run_pre_commit.dart
''';

void writePreCommitHook({String repoRoot = '.'}) {
  final hooksDir = Directory('$repoRoot/$hooksDirectory');
  if (!hooksDir.existsSync()) {
    hooksDir.createSync(recursive: true);
  }

  final hookFile = File('$repoRoot/$preCommitHookPath');
  hookFile.writeAsStringSync(preCommitHookContent());

  final chmodResult = Process.runSync('chmod', ['+x', hookFile.path]);
  if (chmodResult.exitCode != 0) {
    throw ProcessException(
      'chmod',
      ['+x', hookFile.path],
      chmodResult.stderr?.toString() ?? '',
      chmodResult.exitCode,
    );
  }
}

void configureGitHooksPath({String repoRoot = '.'}) {
  final result = Process.runSync('git', [
    'config',
    'core.hooksPath',
    hooksDirectory,
  ], workingDirectory: repoRoot);

  if (result.exitCode != 0) {
    throw ProcessException(
      'git',
      ['config', 'core.hooksPath', hooksDirectory],
      result.stderr?.toString() ?? '',
      result.exitCode,
    );
  }
}

void main(List<String> arguments) {
  writePreCommitHook();
  configureGitHooksPath();
  stdout.writeln('Installed git hooks at $preCommitHookPath');
}
