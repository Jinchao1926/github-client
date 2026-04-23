import 'package:flutter/material.dart';
import 'package:github_client/l10n/l10n.dart';
import 'package:github_client/pages/routes/index.dart';
import 'package:github_client/providers/auth_provider.dart';
import 'package:github_client/themes/index.dart';
import 'package:provider/provider.dart';
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
            title: Text(context.l10n.profileTitle),
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
              child: user == null
                  ? null
                  : UserProfile(user: user, onSignOut: provider.signOut),
            ),
          ),
        );
      },
    );
  }
}
