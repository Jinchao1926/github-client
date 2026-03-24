import 'package:flutter/material.dart';
import 'package:flutter_github/pages/routes/index.dart';
import 'package:flutter_github/providers/auth_provider.dart';
import 'package:flutter_github/themes/index.dart';
import 'package:provider/provider.dart';

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
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Signing in...'),
                      ],
                    )
                  : user == null
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.account_circle_outlined,
                          size: 72,
                          color: ThemeColors.primaryColor(context),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Connect your GitHub account',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Sign in to see your GitHub profile information here.',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: provider.signIn,
                          child: const Text('Sign in with GitHub'),
                        ),
                        if (provider.errorMessage != null) ...[
                          const SizedBox(height: 12),
                          Text(
                            provider.errorMessage!,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ],
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundImage: user.avatarUrl.isEmpty
                              ? null
                              : NetworkImage(user.avatarUrl),
                          child: user.avatarUrl.isEmpty
                              ? const Icon(Icons.person)
                              : null,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          user.name ?? user.login,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(user.login),
                        if (user.bio != null) ...[
                          const SizedBox(height: 8),
                          Text(user.bio!, textAlign: TextAlign.center),
                        ],
                        const SizedBox(height: 16),
                        OutlinedButton(
                          onPressed: provider.signOut,
                          child: const Text('Sign out'),
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}
