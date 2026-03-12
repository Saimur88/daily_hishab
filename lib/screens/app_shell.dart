import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';

class AppShell extends StatelessWidget {
  const AppShell({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
              index,
            initialLocation: index == navigationShell.currentIndex
          );
        },
        destinations: [
           NavigationDestination(
              icon: Icon(Ionicons.home_outline),
               label: 'Home'),
          NavigationDestination(
              icon: Icon(Ionicons.pie_chart_outline),
              label: 'Statistics'),
          NavigationDestination(
              icon: Icon(Ionicons.settings_outline),
              label: 'Settings'),
        ],

      ),
    );
  }
}
