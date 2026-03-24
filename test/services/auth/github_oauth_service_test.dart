import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_github/services/auth/github_oauth_service.dart';

void main() {
  test('createCodeChallenge returns URL-safe non-empty string', () {
    const verifier = 'plain-text-code-verifier-1234567890';

    final challenge = GitHubOAuthService.createCodeChallenge(verifier);

    expect(challenge, isNotEmpty);
    expect(challenge.contains('+'), isFalse);
    expect(challenge.contains('/'), isFalse);
    expect(challenge.contains('='), isFalse);
  });
}
