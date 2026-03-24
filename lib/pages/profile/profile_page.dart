import 'package:flutter/material.dart';
import 'package:flutter_github/pages/routes/index.dart';
import 'package:flutter_github/providers/auth_provider.dart';
import 'package:flutter_github/themes/index.dart';
import 'package:provider/provider.dart';
import 'widgets/login_in.dart';
import 'widgets/logging_in.dart';
import 'widgets/user_profile.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, provider, _) {
        final user = provider.user;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Profile'),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.settings,
                  color: ThemeColors.primaryColor(context),
                ),
                onPressed: () {
                  AppRoutes.pushNamed(context, RoutePaths.settings);
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.share,
                  color: ThemeColors.primaryColor(context),
                ),
                onPressed: () {},
              ),
            ],
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: provider.isInitializing || provider.isSigningIn
                  ? LoggingIn()
                  : user == null
                  ? LoginIn(
                      onSignIn: provider.signIn,
                      errorMessage: provider.errorMessage,
                    )
                  : UserProfile(user: user, onSignOut: provider.signOut),
            ),
          ),
        );
      },
    );
  }
}
