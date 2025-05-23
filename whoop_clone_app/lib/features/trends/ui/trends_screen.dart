import 'package:flutter/material.dart';

class TrendsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Health Trends'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'RHR Trend (Last 7 days): [Chart Placeholder]',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Placeholder(fallbackHeight: 150), // Placeholder for RHR chart
            SizedBox(height: 30),
            Text(
              'HRV Trend (Last 7 days): [Chart Placeholder]',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Placeholder(fallbackHeight: 150), // Placeholder for HRV chart
            SizedBox(height: 30),
            Text(
              'Sleep Duration Trend (Last 7 days): [Chart Placeholder]',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Placeholder(fallbackHeight: 150), // Placeholder for Sleep Duration chart
          ],
        ),
      ),
    );
  }
}
