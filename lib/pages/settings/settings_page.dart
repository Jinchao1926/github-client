import 'package:flutter/material.dart';
import 'package:flutter_github/pages/routes/index.dart';
import 'package:flutter_github/widgets/common/inset_grouped_section.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          InsetGroupedSection(
            children: [
              ListTile(
                title: const Text('Appearance'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  AppRoutes.pushNamed(context, RoutePaths.appearance);
                },
              ),
              ListTile(title: const Text('App Icon'), onTap: () {}),
              ListTile(title: const Text('App Language'), onTap: () {}),
              ListTile(title: const Text('Notification'), onTap: () {}),
              ListTile(title: const Text('Code Options'), onTap: () {}),
              ListTile(title: const Text('External Links'), onTap: () {}),
            ],
          ),
          InsetGroupedSection(
            children: [
              ListTile(title: const Text('Copilot'), onTap: () {}),
              ListTile(title: const Text('Copilot Pro'), onTap: () {}),
            ],
          ),
          InsetGroupedSection(
            children: [
              ListTile(title: const Text('Share Feedback'), onTap: () {}),
            ],
          ),
          InsetGroupedSection(
            children: [
              ListTile(title: const Text('Terms of Service'), onTap: () {}),
            ],
          ),
        ],
      ),
    );
  }
}
