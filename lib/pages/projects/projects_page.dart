import 'package:flutter/material.dart';
import 'package:flutter_github/l10n/l10n.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.projectsTitle)),
      body: Center(child: Text(context.l10n.projectsContent)),
    );
  }
}
