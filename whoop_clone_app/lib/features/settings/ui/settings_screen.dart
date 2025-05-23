import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Link to HealthKit Permissions'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Placeholder for HealthKit permissions logic
            },
          ),
          // Add other settings options here as needed
        ],
      ),
    );
  }
}
