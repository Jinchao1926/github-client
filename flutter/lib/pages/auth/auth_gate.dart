import 'package:flutter/material.dart';
import 'package:github_client/pages/auth/login_page.dart';
import 'package:github_client/pages/main_tab_page.dart';
import 'package:github_client/pages/auth/widgets/logging_in.dart';
import 'package:github_client/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, provider, _) {
        if (provider.isInitializing) {
          return const Scaffold(body: Center(child: LoggingIn()));
        }

        if (!provider.isAuthenticated) {
          return const LoginPage();
        }

        return const MainTabPage();
      },
    );
  }
}
