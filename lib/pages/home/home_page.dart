import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_github/pages/routes/index.dart';
import 'package:flutter_github/widgets/home/favorites_cell.dart';
import 'package:flutter_github/widgets/home/home_section.dart';
import 'package:flutter_github/widgets/home/my_work_cell.dart';
import 'package:flutter_github/widgets/home/recent_cell.dart';
import 'package:flutter_github/widgets/home/shortcut_cell.dart';

class _HomeAction {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  _HomeAction({required this.title, required this.icon, required this.onTap});
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: ListView(
        children: [
          _buildSearchBar(),
          HomeSection(title: 'My Work', children: _buildMyWorkCells(context)),
          HomeSection(
            title: 'Favorites',
            children: [
              FavoritesCell(title: 'Favorite Repo', onTap: () {}),
              FavoritesCell(title: 'Favorite Org', onTap: () {}),
            ],
          ),
          HomeSection(
            title: 'Shortcuts',
            children: [
              ShortcutCell(title: 'Create Issue', onTap: () {}),
              ShortcutCell(title: 'New PR', onTap: () {}),
            ],
          ),
          HomeSection(
            title: 'Recent',
            children: [
              RecentCell(title: 'Recently opened repo', onTap: () {}),
              RecentCell(title: 'Recent discussion', onTap: () {}),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsetsGeometry.symmetric(horizontal: 24),
      child: CupertinoSearchTextField(placeholder: 'Search Github'),
    );
  }

  List<Widget> _buildMyWorkCells(BuildContext context) {
    final actions = <_HomeAction>[
      _HomeAction(
        title: 'Issues',
        icon: Icons.error_outline,
        onTap: () => AppRoutes.pushNamed(context, RoutePaths.issues),
      ),
      _HomeAction(
        title: 'Pull Requests',
        icon: Icons.merge_type,
        onTap: () => AppRoutes.pushNamed(context, RoutePaths.pullRequests),
      ),
      _HomeAction(
        title: 'Discussions',
        icon: Icons.forum_outlined,
        onTap: () => AppRoutes.pushNamed(context, RoutePaths.discussions),
      ),
      _HomeAction(
        title: 'Projects',
        icon: Icons.folder_open,
        onTap: () => AppRoutes.pushNamed(context, RoutePaths.projects),
      ),
      _HomeAction(
        title: 'Top Repositories',
        icon: Icons.star_border,
        onTap: () => AppRoutes.pushNamed(
          context,
          RoutePaths.repositories,
          arguments: {'type': 'top'},
        ),
      ),
      _HomeAction(
        title: 'Organizations',
        icon: Icons.business,
        onTap: () => AppRoutes.pushNamed(context, RoutePaths.organizations),
      ),
      _HomeAction(
        title: 'Starred',
        icon: Icons.star,
        onTap: () => AppRoutes.pushNamed(
          context,
          RoutePaths.repositories,
          arguments: {'type': 'starred'},
        ),
      ),
    ];

    return actions
        .map(
          (action) => MyWorkCell(
            title: action.title,
            icon: action.icon,
            onTap: action.onTap,
          ),
        )
        .toList();
  }
}
