import 'package:flutter/material.dart';
import 'package:flutter_github/l10n/l10n.dart';
import 'package:flutter_github/pages/explore/explore_page.dart';
import 'package:flutter_github/pages/discussions/discussions_page.dart';
import 'package:flutter_github/pages/home/home_page.dart';
import 'package:flutter_github/pages/issues/issues_page.dart';
import 'package:flutter_github/pages/organizations/organizations_page.dart';
import 'package:flutter_github/pages/projects/projects_page.dart';
import 'package:flutter_github/pages/pull_requests/pull_requests_page.dart';
import 'package:flutter_github/pages/repositories/repositories_page.dart';
import 'package:flutter_github/pages/inbox/inbox_page.dart';
import 'package:flutter_github/pages/profile/profile_page.dart';
import 'package:flutter_github/pages/settings/appearance_page.dart';
import 'package:flutter_github/pages/settings/settings_page.dart';
import 'route_paths.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> get routes => {
    RoutePaths.home: (context) => const HomePage(),
    RoutePaths.inbox: (context) => const InboxPage(),
    RoutePaths.explore: (context) => const ExplorePage(),
    RoutePaths.profile: (context) => const ProfilePage(),
    RoutePaths.issues: (context) => const IssuesPage(),
    RoutePaths.pullRequests: (context) => const PullRequestsPage(),
    RoutePaths.discussions: (context) => const DiscussionsPage(),
    RoutePaths.projects: (context) => const ProjectsPage(),
    RoutePaths.repositories: (context) => const RepositoriesPage(),
    RoutePaths.organizations: (context) => const OrganizationsPage(),
    // settings
    RoutePaths.settings: (context) => const SettingsPage(),
    RoutePaths.appearance: (context) => const AppearancePage(),
  };

  static void pushNamed(
    BuildContext context,
    String routeName, {
    dynamic arguments,
  }) {
    Navigator.of(context).pushNamed(routeName, arguments: arguments);
  }

  static void pushReplacementNamed(
    BuildContext context,
    String routeName, {
    dynamic arguments,
  }) {
    Navigator.of(context).pushReplacementNamed(routeName, arguments: arguments);
  }

  static void pop(BuildContext context, {dynamic result}) {
    Navigator.of(context).pop(result);
  }

  static void popUntil(BuildContext context, String routeName) {
    Navigator.of(context).popUntil(ModalRoute.withName(routeName));
  }

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final String path = settings.name ?? RoutePaths.home;
    final WidgetBuilder? builder = routes[path];

    if (builder != null) {
      return MaterialPageRoute(builder: builder, settings: settings);
    }

    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(title: Text(context.l10n.pageNotFoundTitle)),
        body: Center(child: Text(context.l10n.pageNotFoundMessage)),
      ),
    );
  }
}
