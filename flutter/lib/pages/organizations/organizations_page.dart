import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:github_client/l10n/l10n.dart';
import 'package:github_client/models/github_organization.dart';
import 'package:github_client/services/api/organization_service.dart';
import 'package:github_client/widgets/common/network_avatar.dart';

class OrganizationsPage extends StatefulWidget {
  const OrganizationsPage({super.key});

  @override
  State<OrganizationsPage> createState() => _OrganizationsPageState();
}

class _OrganizationsPageState extends State<OrganizationsPage> {
  late final OrganizationService _organizationService;

  @override
  void initState() {
    super.initState();
    _organizationService = OrganizationService();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.organizationsTitle)),
      body: FutureBuilder<List<GithubOrganization>>(
        future: _organizationService.getOrganizations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final organizations = snapshot.data ?? const <GithubOrganization>[];
          if (organizations.isEmpty) {
            return Center(child: Text(l10n.organizationsEmpty));
          }

          return _buildOrganizationList(organizations);
        },
      ),
    );
  }

  Widget _buildOrganizationList(List<GithubOrganization> organizations) {
    return ListView(
      children: [
        CupertinoListSection(
          children: organizations
              .map(
                (organization) => ListTile(
                  leading: NetworkAvatar(imageUrl: organization.avatarUrl),
                  title: Text(organization.login),
                  subtitle: Text(
                    organization.description?.isEmpty ?? true
                        ? organization.login
                        : organization.description!,
                  ),
                  onTap: () {},
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
