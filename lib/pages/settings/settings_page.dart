import 'package:flutter/material.dart';
import 'package:flutter_github/pages/routes/index.dart';
import 'package:flutter_github/themes/index.dart';
import 'package:flutter_github/widgets/common/inset_grouped_section.dart';
import 'package:flutter_github/widgets/common/list_cell.dart';
import 'package:flutter_github/utils/string_utils.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final themeName = StringUtils.capitalize(themeProvider.currentTheme.name);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          InsetGroupedSection(
            children: [
              ListCell(
                title: 'Appearance',
                detail: themeName,
                onTap: () {
                  AppRoutes.pushNamed(context, RoutePaths.appearance);
                },
              ),
              ListCell(title: 'App Icon'),
              ListCell(title: 'App Language', detail: 'English'),
              ListCell(title: 'Notification'),
              ListCell(title: 'Code Options'),
              ListCell(title: 'External Links'),
            ],
          ),
          InsetGroupedSection(
            children: [
              ListCell(title: 'Copilot', detail: 'Copilot Free'),
              ListCell(title: 'Copilot Pro'),
            ],
          ),
          InsetGroupedSection(children: [ListCell(title: 'Share Feedback')]),
          InsetGroupedSection(
            children: [
              ListCell(title: 'Terms of Service'),
              ListCell(title: 'Privacy Policy & Analytics'),
            ],
          ),
          InsetGroupedSection(children: [ListCell(title: 'Feature Preview')]),
          InsetGroupedSection(
            children: [
              ListCell(title: 'Manage Accounts'),
              ListCell(title: 'App Lock'),
            ],
          ),
          InsetGroupedSection(
            children: [
              ListCell(
                title: 'Clear Cache',
                detail: '80.2 MB',
                showChevron: false,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
