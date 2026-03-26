import 'package:flutter/material.dart';
import 'package:flutter_github/l10n/l10n.dart';

class LoggingIn extends StatelessWidget {
  const LoggingIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircularProgressIndicator(),
        const SizedBox(height: 12),
        Text(context.l10n.signingIn),
      ],
    );
  }
}
