import 'package:flutter/material.dart';
import 'package:flutter_github/l10n/l10n.dart';
import 'package:flutter_github/themes/index.dart';

class LoginIn extends StatelessWidget {
  final VoidCallback onSignIn;
  final String? errorMessage;

  const LoginIn({super.key, required this.onSignIn, this.errorMessage});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.account_circle_outlined,
          size: 72,
          color: ThemeColors.primaryColor(context),
        ),
        const SizedBox(height: 16),

        Text(
          l10n.connectGithubAccount,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),

        Text(l10n.profileSigninDescription, textAlign: TextAlign.center),
        const SizedBox(height: 16),

        ElevatedButton(onPressed: onSignIn, child: Text(l10n.signinWithGithub)),

        if (errorMessage != null) ...[
          const SizedBox(height: 12),
          Text(
            errorMessage!,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}
