import 'package:flutter/material.dart';

class NetworkAvatar extends StatelessWidget {
  final String imageUrl;
  final double size;
  final double borderRadius;
  final IconData fallbackIcon;

  const NetworkAvatar({
    super.key,
    required this.imageUrl,
    this.size = 40,
    this.borderRadius = 8,
    this.fallbackIcon = Icons.image_outlined,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: imageUrl.isEmpty
          ? _buildFallback(colorScheme)
          : Image.network(
              imageUrl,
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return _buildFallback(colorScheme);
              },
            ),
    );
  }

  Widget _buildFallback(ColorScheme colorScheme) {
    return Container(
      width: size,
      height: size,
      color: colorScheme.surfaceContainerHighest,
      child: Icon(fallbackIcon, color: colorScheme.onSurfaceVariant),
    );
  }
}
