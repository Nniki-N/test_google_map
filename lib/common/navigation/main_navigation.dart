
import 'package:flutter/material.dart';
import 'package:test_google_map/presentation/screens/compass_screen.dart';
import 'package:test_google_map/presentation/screens/initial_screen.dart';
import 'package:test_google_map/presentation/screens/map_screen.dart';

class MainNavigationRouteNames {
  static const initialScreen = '/';
  static const mapScreen = '/main';
  static const compassScreen = '/main/compass';
}

abstract class MainNavigation {
  static const initialRoute = MainNavigationRouteNames.initialScreen;

  static final routes = <String, Widget Function(BuildContext)>{
    MainNavigationRouteNames.initialScreen: (context) => const InitialScreen(),
    MainNavigationRouteNames.mapScreen: (context) => const MapScreen(),
    MainNavigationRouteNames.compassScreen: (context) => const CompassScreen(),
  };
}
