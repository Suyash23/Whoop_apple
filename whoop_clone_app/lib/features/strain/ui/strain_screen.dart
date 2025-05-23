import 'package:flutter/material.dart';

class StrainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Strain'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Daily Strain Score: --',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Contributing Activities:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: <Widget>[
                  ListTile(
                    title: Text('Workout - 60 mins'),
                    // Placeholder for potential trailing data or icon
                  ),
                  ListTile(
                    title: Text('Walk - 30 mins'),
                    // Placeholder for potential trailing data or icon
                  ),
                  ListTile(
                    title: Text('Morning Run - 45 mins'),
                    // Placeholder for potential trailing data or icon
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
