import 'package:flutter/material.dart';
import 'package:github_client/widgets/common/list_cell.dart';

class RecentCell extends ListCell {
  const RecentCell({super.key, required super.title, required super.onTap})
    : super(leading: const Icon(Icons.favorite, color: Colors.red));
}
