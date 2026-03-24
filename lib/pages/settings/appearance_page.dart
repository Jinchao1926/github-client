import 'package:flutter/material.dart';
import 'package:flutter_github/themes/index.dart';
import 'package:provider/provider.dart';

class AppearancePage extends StatelessWidget {
  const AppearancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Appearance')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Theme Mode',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return Column(
                  children: [
                    RadioListTile<ThemeMode>(
                      title: const Text('Automatic'),
                      value: ThemeMode.system,
                      groupValue: themeProvider.currentTheme,
                      onChanged: (value) {
                        if (value != null) {
                          themeProvider.setSystemTheme();
                        }
                      },
                    ),
                    RadioListTile<ThemeMode>(
                      title: const Text('Light'),
                      value: ThemeMode.light,
                      groupValue: themeProvider.currentTheme,
                      onChanged: (value) {
                        if (value != null) {
                          themeProvider.setLightTheme();
                        }
                      },
                    ),
                    RadioListTile<ThemeMode>(
                      title: const Text('Dark'),
                      value: ThemeMode.dark,
                      groupValue: themeProvider.currentTheme,
                      onChanged: (value) {
                        if (value != null) {
                          themeProvider.setDarkTheme();
                        }
                      },
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            Text(
              'Current theme: ${Provider.of<ThemeProvider>(context).currentTheme.name}',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
          ],
        ),
      ),
    );
  }
}
