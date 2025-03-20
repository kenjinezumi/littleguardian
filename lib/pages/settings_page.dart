// lib/pages/settings_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProv = context.watch<ThemeProvider>();
    final isDark = themeProv.isDarkMode;

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text("Dark Mode"),
            value: isDark,
            onChanged: (value) {
              themeProv.toggleTheme(value);
            },
          ),
          ListTile(
            title: const Text("System Default"),
            subtitle: const Text("Follow the system theme setting"),
            onTap: () {
              themeProv.setSystemMode();
            },
          ),
        ],
      ),
    );
  }
}
