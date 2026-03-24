import 'package:flutter/material.dart';

class RepositoriesPage extends StatelessWidget {
  const RepositoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final type = args?['type'] as String? ?? 'top';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          type == 'starred' ? 'Starred Repositories' : 'Top Repositories',
        ),
      ),
      body: Center(
        child: Text(
          type == 'starred'
              ? 'Starred Repositories Page'
              : 'Top Repositories Page',
        ),
      ),
    );
  }
}
