import 'package:flutter/material.dart';

class ShortcutCell extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const ShortcutCell({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.flash_on, color: Colors.green),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
