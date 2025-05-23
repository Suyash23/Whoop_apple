import 'package:flutter/material.dart';
import 'package:whoop_clone_app/navigation/app_router.dart'; // Import AppRouter

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Current Heart Rate: -- BPM',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Recovery Score: --%',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Strain Score: --',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Sleep Performance: -- hrs',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRouter.strain); // Navigate to Strain screen
              },
              child: Text('View Strain Details'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRouter.recovery); // Navigate to Recovery screen
              },
              child: Text('View Recovery Details'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRouter.sleep); // Navigate to Sleep screen
              },
              child: Text('View Sleep Details'),
            ),
          ],
        ),
      ),
    );
  }
}
