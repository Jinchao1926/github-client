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
import 'package:flutter_github/pages/settings/appearance_page.dart';
import 'package:flutter_github/pages/settings/settings_page.dart';
import 'route_paths.dart';

class AppRoutes {
  // 路由映射
  static Map<String, WidgetBuilder> get routes => {
    // home
    RoutePaths.home: (context) => const HomePage(),
    RoutePaths.inbox: (context) => const InboxPage(),
    RoutePaths.explore: (context) => const ExplorePage(),
    RoutePaths.profile: (context) => const ProfilePage(),
    // business
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

  // 路由生成（用于 MaterialApp 的 onGenerateRoute）
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final String path = settings.name ?? RoutePaths.home;
    final WidgetBuilder? builder = routes[path];

    if (builder != null) {
      return MaterialPageRoute(builder: builder, settings: settings);
    }

    // 未知路由 404
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(title: const Text('页面不存在')),
        body: const Center(child: Text('404 - 页面未找到')),
      ),
    );
  }
}
