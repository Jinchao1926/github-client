import 'package:flutter/material.dart';
import 'package:flutter_github/themes/index.dart';

class ListCell extends StatelessWidget {
  final String title;
  final Widget? leading;
  final String? detail;
  final bool showChevron;
  final VoidCallback onTap;

  const ListCell({
    super.key,
    required this.title,
    this.leading,
    this.detail,
    this.showChevron = true,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: Text(title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (detail != null) ...[
            Text(
              detail!,
              style: TextStyle(
                fontSize: 16,
                color: ThemeColors.secondaryTextColor(context),
              ),
            ),
            if (showChevron) const SizedBox(width: 4),
          ],

          if (showChevron)
            Icon(Icons.chevron_right, color: ThemeColors.arrowColor(context)),
        ],
      ),
      onTap: onTap,
    );
  }
}
