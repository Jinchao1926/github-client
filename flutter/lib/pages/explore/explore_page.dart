import 'package:flutter/material.dart';
import 'package:github_client/l10n/l10n.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.exploreTitle)),
      body: Center(child: Text(context.l10n.exploreWelcome)),
    );
  }
}
