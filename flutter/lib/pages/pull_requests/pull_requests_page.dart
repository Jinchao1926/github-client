import 'package:flutter/material.dart';
import 'package:github_client/l10n/l10n.dart';

class PullRequestsPage extends StatelessWidget {
  const PullRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.pullRequestsTitle)),
      body: Center(child: Text(context.l10n.pullRequestsContent)),
    );
  }
}
