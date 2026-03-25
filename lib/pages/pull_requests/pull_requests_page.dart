import 'package:flutter/material.dart';

class PullRequestsPage extends StatelessWidget {
  const PullRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pull Requests')),
      body: const Center(child: Text('Pull Requests Content')),
    );
  }
}
