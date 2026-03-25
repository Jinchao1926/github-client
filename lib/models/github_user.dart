import 'package:json_annotation/json_annotation.dart';

part 'github_user.g.dart';

@JsonSerializable()
class GitHubUser {
  const GitHubUser({
    required this.login,
    required this.name,
    required this.avatarUrl,
    required this.bio,
  });

  final String login;
  final String? name;
  @JsonKey(name: 'avatar_url')
  final String avatarUrl;
  final String? bio;

  factory GitHubUser.fromJson(Map<String, dynamic> json) =>
      _$GitHubUserFromJson(json);

  Map<String, dynamic> toJson() => _$GitHubUserToJson(this);
}
