import 'package:flutter/material.dart';
import 'package:github_client/pages/auth/widgets/logging_in.dart';
import 'package:github_client/pages/auth/widgets/login_in.dart';
import 'package:github_client/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: provider.isSigningIn
                  ? const LoggingIn()
                  : LoginIn(
                      onSignIn: provider.signIn,
                      errorMessage: provider.errorMessage,
                    ),
            ),
          ),
        );
      },
    );
  }
}
