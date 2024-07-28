import 'package:flutter/material.dart';

/// A settings screen typically used for managing user preferences and app configurations.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkTheme = false;
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: <Widget>[
          SwitchListTile(
            title: const Text('Dark Theme'),
            value: _darkTheme,
            onChanged: (bool value) {
              setState(() {
                _darkTheme = value;
                // Add logic to change the theme in the app
              });
            },
            secondary: const Icon(Icons.lightbulb_outline),
          ),
          SwitchListTile(
            title: const Text('Enable Notifications'),
            value: _notificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _notificationsEnabled = value;
                // Add logic to manage notifications settings
              });
            },
            secondary: const Icon(Icons.notifications_active),
          ),
          ListTile(
            title: const Text('Account Settings'),
            leading: const Icon(Icons.person),
            onTap: () {
              // Navigate to account settings page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AccountSettingsScreen()),
              );
            },
          ),
          ListTile(
            title: const Text('About'),
            leading: const Icon(Icons.info),
            onTap: () {
              // Show about dialog or navigate to about screen
              showAboutDialog(
                context: context,
                applicationName: 'App Name',
                applicationVersion: '1.0.0',
                applicationLegalese: '© 2023 Company Name',
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Placeholder widget for AccountSettingsScreen, replace with actual implementation.
class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Settings'),
      ),
      body: const Center(
        child: Text('Account settings go here.'),
      ),
    );
  }
}
