// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'github_organization.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GithubOrganization _$GithubOrganizationFromJson(Map<String, dynamic> json) =>
    GithubOrganization(
      id: (json['id'] as num).toInt(),
      login: json['login'] as String,
      avatarUrl: json['avatar_url'] as String,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$GithubOrganizationToJson(GithubOrganization instance) =>
    <String, dynamic>{
      'id': instance.id,
      'login': instance.login,
      'avatar_url': instance.avatarUrl,
      'description': instance.description,
    };
