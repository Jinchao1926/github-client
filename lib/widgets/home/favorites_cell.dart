import 'package:flutter/material.dart';

class FavoritesCell extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const FavoritesCell({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.favorite, color: Colors.red),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
