import 'package:json_annotation/json_annotation.dart';

part 'github_organization.g.dart';

@JsonSerializable()
class GithubOrganization {
  const GithubOrganization({
    required this.id,
    required this.login,
    required this.avatarUrl,
    required this.description,
  });

  final int id;
  final String login;
  @JsonKey(name: 'avatar_url')
  final String avatarUrl;
  final String? description;

  factory GithubOrganization.fromJson(Map<String, dynamic> json) =>
      _$GithubOrganizationFromJson(json);

  Map<String, dynamic> toJson() => _$GithubOrganizationToJson(this);
}
