import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:github_client/config/github_auth_config.dart';
import 'package:github_client/main.dart' as app;

void main() {
  setUp(() {
    dotenv = DotEnv();
  });

  test('ignores legacy callback url key from env file', () {
    dotenv.testLoad(
      fileInput: '''
GITHUB_CLIENT_ID=test-client-id
GITHUB_CLIENT_SECRET=test-client-secret
GITHUB_CALLBACK_URL=test-scheme
GITHUB_CALLBACK_HOST=test-host
''',
    );

    expect(GitHubAuthConfig.clientId, 'test-client-id');
    expect(GitHubAuthConfig.clientSecret, 'test-client-secret');
    expect(GitHubAuthConfig.callbackScheme, 'jinchaohub');
    expect(GitHubAuthConfig.callbackHost, 'test-host');
    expect(GitHubAuthConfig.redirectUri, 'jinchaohub://test-host');
  });

  test('loadEnvironment waits for env asset loading', () async {
    dotenv = DotEnv();
    TestWidgetsFlutterBinding.ensureInitialized();

    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMessageHandler('flutter/assets', (message) async {
      final key = utf8.decode(message!.buffer.asUint8List());
      if (key != '.env') {
        return null;
      }

      await Future<void>.delayed(const Duration(milliseconds: 20));
      final bytes = Uint8List.fromList(
        utf8.encode('''
GITHUB_CLIENT_ID=test-client-id
GITHUB_CLIENT_SECRET=test-client-secret
GITHUB_CALLBACK_SCHEME=test-scheme
GITHUB_CALLBACK_HOST=test-host
'''),
      );
      return ByteData.sublistView(bytes);
    });

    await app.loadEnvironment();

    expect(dotenv.isInitialized, isTrue);

    messenger.setMockMessageHandler('flutter/assets', null);
  });
}
