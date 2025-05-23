import 'package:flutter/material.dart';
import 'package:whoop_clone_app/features/dashboard/ui/dashboard_screen.dart';
import 'package:whoop_clone_app/features/strain/ui/strain_screen.dart';
import 'package:whoop_clone_app/features/recovery/ui/recovery_screen.dart';
import 'package:whoop_clone_app/features/sleep/ui/sleep_screen.dart';
import 'package:whoop_clone_app/features/trends/ui/trends_screen.dart';
import 'package:whoop_clone_app/features/settings/ui/settings_screen.dart';

class AppRouter {
  static const String dashboard = '/';
  static const String strain = '/strain';
  static const String recovery = '/recovery';
  static const String sleep = '/sleep';
  static const String trends = '/trends';
  static const String settings = '/settings';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case dashboard:
        return MaterialPageRoute(builder: (_) => DashboardScreen());
      case strain:
        return MaterialPageRoute(builder: (_) => StrainScreen());
      case recovery:
        return MaterialPageRoute(builder: (_) => RecoveryScreen());
      case sleep:
        return MaterialPageRoute(builder: (_) => SleepScreen());
      case trends:
        return MaterialPageRoute(builder: (_) => TrendsScreen());
      case settings:
        return MaterialPageRoute(builder: (_) => SettingsScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
