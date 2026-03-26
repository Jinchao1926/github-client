import 'package:flutter/material.dart';
import 'package:flutter_github/l10n/l10n.dart';
import 'package:flutter_github/widgets/common/inset_grouped_section.dart';

class OrganizationsPage extends StatelessWidget {
  const OrganizationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.organizationsTitle)),
      body: ListView(
        children: [
          InsetGroupedSection(
            children: [
              ListTile(
                leading: const CircleAvatar(child: Text('A')),
                title: Text(l10n.organizationAName),
                subtitle: Text(l10n.organizationADescription),
                onTap: () {},
              ),
              ListTile(
                leading: const CircleAvatar(child: Text('B')),
                title: Text(l10n.organizationBName),
                subtitle: Text(l10n.organizationBDescription),
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
