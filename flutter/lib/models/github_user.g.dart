// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'github_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GitHubUser _$GitHubUserFromJson(Map<String, dynamic> json) => GitHubUser(
  login: json['login'] as String,
  name: json['name'] as String?,
  avatarUrl: json['avatar_url'] as String,
  bio: json['bio'] as String?,
);

Map<String, dynamic> _$GitHubUserToJson(GitHubUser instance) =>
    <String, dynamic>{
      'login': instance.login,
      'name': instance.name,
      'avatar_url': instance.avatarUrl,
      'bio': instance.bio,
    };
