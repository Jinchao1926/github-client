import 'package:flutter/material.dart';
import 'package:flutter_github/l10n/l10n.dart';
import 'package:flutter_github/pages/routes/index.dart';
import 'package:flutter_github/providers/locale_provider.dart';
import 'package:flutter_github/themes/index.dart';
import 'package:flutter_github/widgets/common/inset_grouped_section.dart';
import 'package:flutter_github/widgets/common/list_cell.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    final l10n = context.l10n;
    final themeName = switch (themeProvider.currentTheme) {
      ThemeMode.system => l10n.themeAutomatic,
      ThemeMode.dark => l10n.themeDark,
      ThemeMode.light => l10n.themeLight,
    };
    final languageName = switch (localeProvider.currentLocale?.languageCode) {
      'zh' => l10n.languageChineseSimplified,
      'en' => l10n.languageEnglish,
      _ => l10n.languageSystem,
    };

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        children: [
          InsetGroupedSection(
            dividerAlignLeft: true,
            children: [
              ListCell(
                title: l10n.appearanceLabel,
                detail: themeName,
                onTap: () {
                  AppRoutes.pushNamed(context, RoutePaths.appearance);
                },
              ),
              ListCell(title: l10n.appIconLabel),
              ListCell(
                title: l10n.appLanguageLabel,
                detail: languageName,
                onTap: () => _showLanguagePicker(context),
              ),
              ListCell(title: l10n.notificationLabel),
              ListCell(title: l10n.codeOptionsLabel),
              ListCell(title: l10n.externalLinksLabel),
            ],
          ),
          InsetGroupedSection(
            dividerAlignLeft: true,
            children: [
              ListCell(title: l10n.copilotLabel, detail: l10n.copilotFreePlan),
              ListCell(title: l10n.copilotProLabel),
            ],
          ),
          InsetGroupedSection(
            children: [ListCell(title: l10n.shareFeedbackLabel)],
          ),
          InsetGroupedSection(
            dividerAlignLeft: true,
            children: [
              ListCell(title: l10n.termsOfServiceLabel),
              ListCell(title: l10n.privacyPolicyAnalyticsLabel),
            ],
          ),
          InsetGroupedSection(
            children: [ListCell(title: l10n.featurePreviewLabel)],
          ),
          InsetGroupedSection(
            dividerAlignLeft: true,
            children: [
              ListCell(title: l10n.manageAccountsLabel),
              ListCell(title: l10n.appLockLabel),
            ],
          ),
          InsetGroupedSection(
            children: [
              ListCell(
                title: l10n.clearCacheLabel,
                detail: '80.2 MB',
                showChevron: false,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _showLanguagePicker(BuildContext context) async {
    final localeProvider = context.read<LocaleProvider>();
    final l10n = context.l10n;

    await showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) {
        final currentCode = localeProvider.currentLocale?.languageCode;

        return SafeArea(
          child: RadioGroup<String?>(
            groupValue: currentCode,
            onChanged: (value) async {
              switch (value) {
                case 'en':
                  await localeProvider.setLocale(const Locale('en'));
                  break;
                case 'zh':
                  await localeProvider.setLocale(const Locale('zh'));
                  break;
                default:
                  await localeProvider.useSystemLocale();
                  break;
              }

              if (sheetContext.mounted) {
                Navigator.of(sheetContext).pop();
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(title: Text(l10n.languagePickerTitle)),
                RadioListTile<String?>(
                  value: null,
                  title: Text(l10n.languageSystem),
                ),
                RadioListTile<String?>(
                  value: 'en',
                  title: Text(l10n.languageEnglish),
                ),
                RadioListTile<String?>(
                  value: 'zh',
                  title: Text(l10n.languageChineseSimplified),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
