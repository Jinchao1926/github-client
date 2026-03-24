import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_github/models/github_user.dart';

void main() {
  test('GitHubUser.fromJson parses expected fields', () {
    final user = GitHubUser.fromJson(const {
      'login': 'octocat',
      'name': 'The Octocat',
      'avatar_url': 'https://example.com/avatar.png',
      'bio': 'Mascot',
    });

    expect(user.login, 'octocat');
    expect(user.name, 'The Octocat');
    expect(user.avatarUrl, 'https://example.com/avatar.png');
    expect(user.bio, 'Mascot');
  });
}
