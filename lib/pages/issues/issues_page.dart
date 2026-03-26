import 'package:flutter/material.dart';
import 'package:flutter_github/l10n/l10n.dart';

class IssuesPage extends StatelessWidget {
  const IssuesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.issuesTitle)),
      body: Center(child: Text(context.l10n.issuesContent)),
    );
  }
}
