import 'package:flutter/material.dart';

class RecentCell extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const RecentCell({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.history, color: Colors.grey),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
