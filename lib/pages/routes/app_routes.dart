import 'package:flutter/material.dart';
import 'package:flutter_github/pages/explore/explore_page.dart';
import 'package:flutter_github/pages/home/discussions_page.dart';
import 'package:flutter_github/pages/home/home_page.dart';
import 'package:flutter_github/pages/home/issues_page.dart';
import 'package:flutter_github/pages/home/organizations_page.dart';
import 'package:flutter_github/pages/home/projects_page.dart';
import 'package:flutter_github/pages/home/pull_requests_page.dart';
import 'package:flutter_github/pages/home/repositories_page.dart';
import 'package:flutter_github/pages/inbox/inbox_page.dart';
import 'package:flutter_github/pages/profile/profile_page.dart';
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
        appBar: AppBar(title: const Text('页面不存在')),
        body: const Center(child: Text('404 - 页面未找到')),
      ),
    );
  }
}
