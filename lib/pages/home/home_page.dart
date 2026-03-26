import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_github/l10n/l10n.dart';
import 'package:flutter_github/pages/routes/index.dart';
import 'package:flutter_github/pages/home/widgets/favorites_cell.dart';
import 'package:flutter_github/widgets/common/inset_grouped_section.dart';
import 'package:flutter_github/pages/home/widgets/my_work_cell.dart';
import 'package:flutter_github/pages/home/widgets/recent_cell.dart';
import 'package:flutter_github/pages/home/widgets/shortcut_cell.dart';

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
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.homeTitle)),
      body: ListView(
        children: [
          _buildSearchBar(context),
          InsetGroupedSection(
            title: l10n.myWorkSection,
            children: _buildMyWorkCells(context),
          ),
          InsetGroupedSection(
            title: l10n.favoritesSection,
            children: [
              FavoritesCell(title: l10n.favoriteRepo, onTap: () {}),
              FavoritesCell(title: l10n.favoriteOrg, onTap: () {}),
            ],
          ),
          InsetGroupedSection(
            title: l10n.shortcutsSection,
            children: [
              ShortcutCell(title: l10n.createIssue, onTap: () {}),
              ShortcutCell(title: l10n.newPr, onTap: () {}),
            ],
          ),
          InsetGroupedSection(
            title: l10n.recentSection,
            children: [
              RecentCell(title: l10n.recentlyOpenedRepo, onTap: () {}),
              RecentCell(title: l10n.recentDiscussion, onTap: () {}),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsGeometry.symmetric(horizontal: 24),
      child: CupertinoSearchTextField(
        placeholder: context.l10n.homeSearchPlaceholder,
      ),
    );
  }

  List<Widget> _buildMyWorkCells(BuildContext context) {
    final l10n = context.l10n;

    final actions = <_HomeAction>[
      _HomeAction(
        title: l10n.issuesTitle,
        icon: Icons.error_outline,
        onTap: () => AppRoutes.pushNamed(context, RoutePaths.issues),
      ),
      _HomeAction(
        title: l10n.pullRequestsTitle,
        icon: Icons.merge_type,
        onTap: () => AppRoutes.pushNamed(context, RoutePaths.pullRequests),
      ),
      _HomeAction(
        title: l10n.discussionsTitle,
        icon: Icons.forum_outlined,
        onTap: () => AppRoutes.pushNamed(context, RoutePaths.discussions),
      ),
      _HomeAction(
        title: l10n.projectsTitle,
        icon: Icons.folder_open,
        onTap: () => AppRoutes.pushNamed(context, RoutePaths.projects),
      ),
      _HomeAction(
        title: l10n.topRepositoriesTitle,
        icon: Icons.star_border,
        onTap: () => AppRoutes.pushNamed(
          context,
          RoutePaths.repositories,
          arguments: {'type': 'top'},
        ),
      ),
      _HomeAction(
        title: l10n.organizationsTitle,
        icon: Icons.business,
        onTap: () => AppRoutes.pushNamed(context, RoutePaths.organizations),
      ),
      _HomeAction(
        title: l10n.starredRepositoriesTitle,
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
