import 'package:flutter/material.dart';
import 'package:flutter_github/pages/home/widgets/list_cell.dart';

class FavoritesCell extends ListCell {
  const FavoritesCell({super.key, required super.title, required super.onTap})
    : super(leading: const Icon(Icons.favorite, color: Colors.red));
}
