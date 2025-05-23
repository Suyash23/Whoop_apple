import 'package:flutter/material.dart';
import 'package:whoop_clone_app/features/dashboard/ui/dashboard_screen.dart';
import 'package:whoop_clone_app/features/trends/ui/trends_screen.dart';
import 'package:whoop_clone_app/features/settings/ui/settings_screen.dart';
import 'package:whoop_clone_app/navigation/app_router.dart'; // Import AppRouter

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Whoop Clone App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      onGenerateRoute: AppRouter.generateRoute, // Use AppRouter for routing
      initialRoute: AppRouter.dashboard, // Set initial route
      // home: MainScreen(), // home is replaced by initialRoute when using onGenerateRoute
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    DashboardScreen(),
    TrendsScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // This is a simplified navigation for the BottomNavigationBar.
    // More complex navigation patterns might require a different approach.
    // For instance, using Navigator.pushNamed within each tab's Navigator stack.
    // However, for this task, changing the body directly is sufficient.
    // If routes defined in AppRouter need to be pushed here, that logic would go here.
    // For now, it just switches the body of the MainScreen.
  }

  @override
  Widget build(BuildContext context) {
    // Wrap the body with a Navigator to ensure that routes pushed from within
    // DashboardScreen, TrendsScreen, or SettingsScreen use the AppRouter.
    // However, since MainScreen itself is presented by AppRouter.dashboard,
    // and the BottomNavigationBar changes the body directly,
    // direct navigation from these screens should use Navigator.pushNamed(context, AppRouter.routeName).

    // For simplicity, and given the current setup, we are directly swapping widgets.
    // If DashboardScreen etc. were to push new routes that should also show the BottomNavBar,
    // a nested Navigator approach would be needed.
    // For this iteration, we assume navigation from Dashboard buttons will replace the whole MainScreen content.
    // If the intent is to keep the BottomNavigationBar visible, then those navigations
    // should be handled differently, possibly by making MainScreen's body a Navigator itself
    // and managing a separate stack of pages for each tab.

    return Scaffold(
      body: IndexedStack( // Use IndexedStack to preserve state of screens in BottomNavigationBar
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: 'Trends',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
