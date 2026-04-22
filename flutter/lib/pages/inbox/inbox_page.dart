import 'package:flutter/material.dart';
import 'package:github_client/l10n/l10n.dart';

class InboxPage extends StatelessWidget {
  const InboxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.inboxTitle)),
      body: Center(child: Text(context.l10n.inboxWelcome)),
    );
  }
}
