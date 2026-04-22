import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
  ];

  /// No description provided for @appIconLabel.
  ///
  /// In en, this message translates to:
  /// **'App Icon'**
  String get appIconLabel;

  /// No description provided for @appLanguageLabel.
  ///
  /// In en, this message translates to:
  /// **'App Language'**
  String get appLanguageLabel;

  /// No description provided for @appLockLabel.
  ///
  /// In en, this message translates to:
  /// **'App Lock'**
  String get appLockLabel;

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Flutter GitHub'**
  String get appTitle;

  /// No description provided for @appearanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearanceLabel;

  /// No description provided for @appearanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearanceTitle;

  /// No description provided for @clearCacheLabel.
  ///
  /// In en, this message translates to:
  /// **'Clear Cache'**
  String get clearCacheLabel;

  /// No description provided for @codeOptionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Code Options'**
  String get codeOptionsLabel;

  /// No description provided for @connectGithubAccount.
  ///
  /// In en, this message translates to:
  /// **'Connect your GitHub account'**
  String get connectGithubAccount;

  /// No description provided for @copilotFreePlan.
  ///
  /// In en, this message translates to:
  /// **'Copilot Free'**
  String get copilotFreePlan;

  /// No description provided for @copilotLabel.
  ///
  /// In en, this message translates to:
  /// **'Copilot'**
  String get copilotLabel;

  /// No description provided for @copilotProLabel.
  ///
  /// In en, this message translates to:
  /// **'Copilot Pro'**
  String get copilotProLabel;

  /// No description provided for @createIssue.
  ///
  /// In en, this message translates to:
  /// **'Create Issue'**
  String get createIssue;

  /// No description provided for @discussionsContent.
  ///
  /// In en, this message translates to:
  /// **'Discussions Content'**
  String get discussionsContent;

  /// No description provided for @discussionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Discussions'**
  String get discussionsTitle;

  /// No description provided for @exploreTab.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get exploreTab;

  /// No description provided for @exploreTitle.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get exploreTitle;

  /// No description provided for @exploreWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to the Explore Page!'**
  String get exploreWelcome;

  /// No description provided for @externalLinksLabel.
  ///
  /// In en, this message translates to:
  /// **'External Links'**
  String get externalLinksLabel;

  /// No description provided for @favoriteOrg.
  ///
  /// In en, this message translates to:
  /// **'Favorite Org'**
  String get favoriteOrg;

  /// No description provided for @favoriteRepo.
  ///
  /// In en, this message translates to:
  /// **'Favorite Repo'**
  String get favoriteRepo;

  /// No description provided for @favoritesSection.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favoritesSection;

  /// No description provided for @featurePreviewLabel.
  ///
  /// In en, this message translates to:
  /// **'Feature Preview'**
  String get featurePreviewLabel;

  /// No description provided for @homeSearchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search GitHub'**
  String get homeSearchPlaceholder;

  /// No description provided for @homeTab.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTab;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTitle;

  /// No description provided for @inboxTab.
  ///
  /// In en, this message translates to:
  /// **'Inbox'**
  String get inboxTab;

  /// No description provided for @inboxTitle.
  ///
  /// In en, this message translates to:
  /// **'Inbox'**
  String get inboxTitle;

  /// No description provided for @inboxWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to the Inbox Page!'**
  String get inboxWelcome;

  /// No description provided for @issuesContent.
  ///
  /// In en, this message translates to:
  /// **'Issues Content'**
  String get issuesContent;

  /// No description provided for @issuesTitle.
  ///
  /// In en, this message translates to:
  /// **'Issues'**
  String get issuesTitle;

  /// No description provided for @languageChineseSimplified.
  ///
  /// In en, this message translates to:
  /// **'Simplified Chinese'**
  String get languageChineseSimplified;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languagePickerTitle.
  ///
  /// In en, this message translates to:
  /// **'App Language'**
  String get languagePickerTitle;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get languageSystem;

  /// No description provided for @manageAccountsLabel.
  ///
  /// In en, this message translates to:
  /// **'Manage Accounts'**
  String get manageAccountsLabel;

  /// No description provided for @myWorkSection.
  ///
  /// In en, this message translates to:
  /// **'My Work'**
  String get myWorkSection;

  /// No description provided for @newPr.
  ///
  /// In en, this message translates to:
  /// **'New PR'**
  String get newPr;

  /// No description provided for @notificationLabel.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get notificationLabel;

  /// No description provided for @organizationADescription.
  ///
  /// In en, this message translates to:
  /// **'Description of Organization A'**
  String get organizationADescription;

  /// No description provided for @organizationAName.
  ///
  /// In en, this message translates to:
  /// **'Organization A'**
  String get organizationAName;

  /// No description provided for @organizationBDescription.
  ///
  /// In en, this message translates to:
  /// **'Description of Organization B'**
  String get organizationBDescription;

  /// No description provided for @organizationBName.
  ///
  /// In en, this message translates to:
  /// **'Organization B'**
  String get organizationBName;

  /// No description provided for @organizationsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No organizations'**
  String get organizationsEmpty;

  /// No description provided for @organizationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Organizations'**
  String get organizationsTitle;

  /// No description provided for @pageNotFoundMessage.
  ///
  /// In en, this message translates to:
  /// **'404 - Page not found'**
  String get pageNotFoundMessage;

  /// No description provided for @pageNotFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Page not found'**
  String get pageNotFoundTitle;

  /// No description provided for @privacyPolicyAnalyticsLabel.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy & Analytics'**
  String get privacyPolicyAnalyticsLabel;

  /// No description provided for @profileSigninDescription.
  ///
  /// In en, this message translates to:
  /// **'Sign in to see your GitHub profile information here.'**
  String get profileSigninDescription;

  /// No description provided for @profileTab.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTab;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @projectsContent.
  ///
  /// In en, this message translates to:
  /// **'Projects Page'**
  String get projectsContent;

  /// No description provided for @projectsTitle.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get projectsTitle;

  /// No description provided for @pullRequestsContent.
  ///
  /// In en, this message translates to:
  /// **'Pull Requests Content'**
  String get pullRequestsContent;

  /// No description provided for @pullRequestsTitle.
  ///
  /// In en, this message translates to:
  /// **'Pull Requests'**
  String get pullRequestsTitle;

  /// No description provided for @recentDiscussion.
  ///
  /// In en, this message translates to:
  /// **'Recent discussion'**
  String get recentDiscussion;

  /// No description provided for @recentSection.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get recentSection;

  /// No description provided for @recentlyOpenedRepo.
  ///
  /// In en, this message translates to:
  /// **'Recently opened repo'**
  String get recentlyOpenedRepo;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @shareFeedbackLabel.
  ///
  /// In en, this message translates to:
  /// **'Share Feedback'**
  String get shareFeedbackLabel;

  /// No description provided for @shortcutsSection.
  ///
  /// In en, this message translates to:
  /// **'Shortcuts'**
  String get shortcutsSection;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @signinWithGithub.
  ///
  /// In en, this message translates to:
  /// **'Sign in with GitHub'**
  String get signinWithGithub;

  /// No description provided for @signingIn.
  ///
  /// In en, this message translates to:
  /// **'Signing in...'**
  String get signingIn;

  /// No description provided for @starredRepositoriesContent.
  ///
  /// In en, this message translates to:
  /// **'Starred Repositories Page'**
  String get starredRepositoriesContent;

  /// No description provided for @starredRepositoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Starred Repositories'**
  String get starredRepositoriesTitle;

  /// No description provided for @termsOfServiceLabel.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfServiceLabel;

  /// No description provided for @themeAutomatic.
  ///
  /// In en, this message translates to:
  /// **'Automatic'**
  String get themeAutomatic;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @topRepositoriesContent.
  ///
  /// In en, this message translates to:
  /// **'Top Repositories Page'**
  String get topRepositoriesContent;

  /// No description provided for @topRepositoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Top Repositories'**
  String get topRepositoriesTitle;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
