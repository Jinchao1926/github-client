import 'package:flutter/material.dart';
import 'package:flutter_github/widgets/common/inset_grouped_section.dart';

class OrganizationsPage extends StatelessWidget {
  const OrganizationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Organizations')),
      body: ListView(
        children: [
          InsetGroupedSection(
            children: [
              ListTile(
                leading: CircleAvatar(child: Text('A')),
                title: Text('Organization A'),
                subtitle: Text('Description of Organization A'),
                onTap: () {},
              ),
              ListTile(
                leading: CircleAvatar(child: Text('B')),
                title: Text('Organization B'),
                subtitle: Text('Description of Organization B'),
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
