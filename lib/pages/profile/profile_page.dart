import 'package:flutter/material.dart';
import 'package:flutter_github/pages/routes/index.dart';
import 'package:flutter_github/themes/index.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
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
            icon: Icon(Icons.share, color: ThemeColors.primaryColor(context)),
            onPressed: () {},
          ),
        ],
      ),
      body: Center(child: Text('Profile Page')),
    );
  }
}
