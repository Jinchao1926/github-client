class GitHubUser {
  const GitHubUser({
    required this.login,
    required this.name,
    required this.avatarUrl,
    required this.bio,
  });

  final String login;
  final String? name;
  final String avatarUrl;
  final String? bio;

  factory GitHubUser.fromJson(Map<String, dynamic> json) {
    return GitHubUser(
      login: json['login'] as String,
      name: json['name'] as String?,
      avatarUrl: json['avatar_url'] as String,
      bio: json['bio'] as String?,
    );
  }
}
