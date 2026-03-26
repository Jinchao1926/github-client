import 'package:flutter/material.dart';
import 'package:flutter_github/l10n/l10n.dart';

class RepositoriesPage extends StatelessWidget {
  const RepositoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final type = args?['type'] as String? ?? 'top';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          type == 'starred'
              ? l10n.starredRepositoriesTitle
              : l10n.topRepositoriesTitle,
        ),
      ),
      body: Center(
        child: Text(
          type == 'starred'
              ? l10n.starredRepositoriesContent
              : l10n.topRepositoriesContent,
        ),
      ),
    );
  }
}
