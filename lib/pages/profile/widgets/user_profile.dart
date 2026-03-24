import 'package:flutter/material.dart';
import 'package:flutter_github/models/github_user.dart';

class UserProfile extends StatelessWidget {
  final GitHubUser user;
  final VoidCallback onSignOut;

  const UserProfile({super.key, required this.user, required this.onSignOut});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 32,
          backgroundImage: user.avatarUrl.isEmpty
              ? null
              : NetworkImage(user.avatarUrl),
          child: user.avatarUrl.isEmpty ? const Icon(Icons.person) : null,
        ),
        const SizedBox(height: 12),
        Text(
          user.name ?? user.login,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(user.login),
        if (user.bio != null) ...[
          const SizedBox(height: 8),
          Text(user.bio!, textAlign: TextAlign.center),
        ],
        const SizedBox(height: 16),
        OutlinedButton(onPressed: onSignOut, child: const Text('Sign out')),
      ],
    );
  }
}
