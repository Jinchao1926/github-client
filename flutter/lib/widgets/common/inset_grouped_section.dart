import 'package:flutter/cupertino.dart';
import 'package:github_client/themes/index.dart';

class InsetGroupedSection extends StatelessWidget {
  final String? title;
  final bool dividerAlignLeft;
  final List<Widget> children;

  const InsetGroupedSection({
    super.key,
    this.title,
    this.dividerAlignLeft = false,
    required this.children,
  });

  /*
  @override
  Widget build(BuildContext context) {
    return Card(
      color: ThemeColors.secondaryBackgroundColor(context),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      child: Column(
        children: List.generate(children.length, (index) {
          final isLast = index == children.length - 1;

          return Column(
            children: [
              children[index],
              if (!isLast) Divider(height: 1, indent: 16),
            ],
          );
        }),
      ),
    );
  } */

  @override
  Widget build(BuildContext context) {
    return CupertinoListSection.insetGrouped(
      header: title != null
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(title!, style: const TextStyle(fontSize: 20)),
            )
          : null,
      additionalDividerMargin: dividerAlignLeft ? 0.0 : null,
      decoration: BoxDecoration(
        color: ThemeColors.secondaryBackgroundColor(context),
        borderRadius: BorderRadius.circular(8.0),
      ),
      children: children,
    );
  }
}
