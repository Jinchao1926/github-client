import 'package:flutter/material.dart';
import 'package:github_client/l10n/l10n.dart';
import 'package:github_client/pages/explore/explore_page.dart';
import 'package:github_client/pages/discussions/discussions_page.dart';
import 'package:github_client/pages/home/home_page.dart';
import 'package:github_client/pages/issues/issues_page.dart';
import 'package:github_client/pages/organizations/organizations_page.dart';
import 'package:github_client/pages/projects/projects_page.dart';
import 'package:github_client/pages/pull_requests/pull_requests_page.dart';
import 'package:github_client/pages/repositories/repositories_page.dart';
import 'package:github_client/pages/inbox/inbox_page.dart';
import 'package:github_client/pages/profile/profile_page.dart';
import 'package:github_client/pages/settings/appearance_page.dart';
import 'package:github_client/pages/settings/settings_page.dart';
import 'route_paths.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> get routes => {
    // main tabs
    RoutePaths.home: (context) => const HomePage(),
    RoutePaths.inbox: (context) => const InboxPage(),
    RoutePaths.explore: (context) => const ExplorePage(),
    RoutePaths.profile: (context) => const ProfilePage(),
    // detail pages
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
