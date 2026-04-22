import 'package:flutter/material.dart';
import 'package:github_client/widgets/common/list_cell.dart';
import 'package:github_client/themes/index.dart';

class MyWorkCell extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const MyWorkCell({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListCell(
      leading: Icon(icon, color: ThemeColors.primaryColor(context)),
      title: title,
      onTap: onTap,
    );
  }
}
