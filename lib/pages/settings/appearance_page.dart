import 'package:flutter/material.dart';
import 'package:flutter_github/l10n/l10n.dart';
import 'package:flutter_github/themes/index.dart';
import 'package:flutter_github/widgets/common/inset_grouped_section.dart';
import 'package:provider/provider.dart';

class AppearancePage extends StatelessWidget {
  const AppearancePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.appearanceTitle)),
      body: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          final currentTheme = themeProvider.currentTheme;

          return RadioGroup<ThemeMode>(
            groupValue: currentTheme,
            onChanged: (value) {
              switch (value) {
                case ThemeMode.system:
                  themeProvider.setSystemTheme();
                  break;
                case ThemeMode.dark:
                  themeProvider.setDarkTheme();
                  break;
                default:
                  themeProvider.setLightTheme();
                  break;
              }
            },
            child: InsetGroupedSection(
              dividerAlignLeft: true,
              children: [
                RadioListTile<ThemeMode>(
                  key: ValueKey('theme_auto'),
                  value: ThemeMode.system,
                  title: Text(l10n.themeAutomatic),
                  controlAffinity: ListTileControlAffinity.trailing,
                ),
                RadioListTile<ThemeMode>(
                  key: ValueKey('theme_dark'),
                  value: ThemeMode.dark,
                  title: Text(l10n.themeDark),
                  controlAffinity: ListTileControlAffinity.trailing,
                ),
                RadioListTile<ThemeMode>(
                  key: ValueKey('theme_light'),
                  value: ThemeMode.light,
                  title: Text(l10n.themeLight),
                  controlAffinity: ListTileControlAffinity.trailing,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
