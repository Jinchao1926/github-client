import 'package:flutter/material.dart';
import 'package:flutter_github/widgets/common/list_cell.dart';

class ShortcutCell extends ListCell {
  const ShortcutCell({super.key, required super.title, required super.onTap})
    : super(leading: const Icon(Icons.flash_on, color: Colors.green));
}
