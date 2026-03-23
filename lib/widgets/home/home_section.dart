import 'package:flutter/cupertino.dart';
import 'package:flutter_github/themes/index.dart';

class HomeSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const HomeSection({super.key, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return CupertinoListSection.insetGrouped(
      header: Padding(
        padding: EdgeInsetsGeometry.symmetric(vertical: 4),
        child: Text(title, style: TextStyle(fontSize: 20)),
      ),
      decoration: BoxDecoration(
        color: ThemeColors.secondaryBackgroundColor(context),
        borderRadius: BorderRadius.circular(8.0),
      ),
      children: children,
    );
  }
}
