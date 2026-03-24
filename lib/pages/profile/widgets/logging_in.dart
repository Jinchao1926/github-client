import 'package:flutter/material.dart';

class LoggingIn extends StatelessWidget {
  const LoggingIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: const [
        CircularProgressIndicator(),
        SizedBox(height: 12),
        Text('Signing in...'),
      ],
    );
  }
}
