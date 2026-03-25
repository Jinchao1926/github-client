import 'package:flutter/material.dart';
import 'package:flutter_github/pages/home/widgets/list_cell.dart';

class MyWorkCell extends ListCell {
  MyWorkCell({
    super.key,
    required IconData icon,
    required super.title,
    required super.onTap,
  }) : super(leading: Icon(icon));
}
