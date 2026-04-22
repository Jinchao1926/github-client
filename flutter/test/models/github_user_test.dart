import 'package:flutter_test/flutter_test.dart';
import 'package:github_client/models/github_user.dart';

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

  test('GitHubUser.toJson serializes expected fields', () {
    const user = GitHubUser(
      login: 'octocat',
      name: 'The Octocat',
      avatarUrl: 'https://example.com/avatar.png',
      bio: 'Mascot',
    );

    expect(user.toJson(), {
      'login': 'octocat',
      'name': 'The Octocat',
      'avatar_url': 'https://example.com/avatar.png',
      'bio': 'Mascot',
    });
  });
}
