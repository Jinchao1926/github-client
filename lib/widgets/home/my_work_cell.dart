import 'package:flutter/material.dart';

class MyWorkCell extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const MyWorkCell({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
