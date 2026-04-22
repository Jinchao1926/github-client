import 'package:flutter/material.dart';
import 'package:github_client/l10n/l10n.dart';

class DiscussionsPage extends StatelessWidget {
  const DiscussionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.discussionsTitle)),
      body: Center(child: Text(context.l10n.discussionsContent)),
    );
  }
}
