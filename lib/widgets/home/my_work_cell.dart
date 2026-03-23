import 'package:flutter/material.dart';
import 'package:flutter_github/themes/index.dart';

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
      leading: Icon(icon, color: ThemeColors.primaryColor(context)),
      title: Text(title),
      trailing: Icon(
        Icons.chevron_right,
        color: ThemeColors.arrowColor(context),
      ),
      onTap: onTap,
    );
  }
}
