import 'package:flutter/material.dart';
import 'package:flutter_github/pages/routes/index.dart';
import 'package:flutter_github/pages/home/widgets/inset_grouped_section.dart';
import 'package:flutter_github/pages/home/widgets/list_cell.dart';

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
              ListCell(
                title: 'Appearance',
                detail: 'Dark',
                onTap: () {
                  AppRoutes.pushNamed(context, RoutePaths.appearance);
                },
              ),
              ListCell(title: 'App Icon', onTap: () {}),
              ListCell(title: 'App Language', onTap: () {}),
              ListCell(title: 'Notification', onTap: () {}),
              ListCell(title: 'Code Options', onTap: () {}),
              ListCell(title: 'External Links', onTap: () {}),
            ],
          ),
          InsetGroupedSection(
            children: [
              ListCell(title: 'Copilot', onTap: () {}),
              ListCell(title: 'Copilot Pro', onTap: () {}),
            ],
          ),
          InsetGroupedSection(
            children: [ListCell(title: 'Share Feedback', onTap: () {})],
          ),
          InsetGroupedSection(
            children: [ListCell(title: 'Terms of Service', onTap: () {})],
          ),
        ],
      ),
    );
  }
}
