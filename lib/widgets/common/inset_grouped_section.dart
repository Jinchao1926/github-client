import 'package:flutter/cupertino.dart';
import 'package:flutter_github/themes/index.dart';

class InsetGroupedSection extends StatelessWidget {
  final String? title;
  final List<Widget> children;

  const InsetGroupedSection({super.key, this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return CupertinoListSection.insetGrouped(
      header: title != null
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(title!, style: const TextStyle(fontSize: 20)),
            )
          : null,
      decoration: BoxDecoration(
        color: ThemeColors.secondaryBackgroundColor(context),
        borderRadius: BorderRadius.circular(8.0),
      ),
      children: children,
    );
  }
}
