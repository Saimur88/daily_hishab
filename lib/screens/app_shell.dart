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
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        backgroundColor: scheme.primary,
        indicatorColor: Colors.transparent,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        labelTextStyle: WidgetStateProperty.all(
          TextStyle(
            fontWeight: FontWeight.bold,
            color: scheme.onInverseSurface,),
        ),
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
              index,
            initialLocation: index == navigationShell.currentIndex
          );
        },
        destinations: [
           NavigationDestination(
              icon: Icon(Ionicons.home_outline,size: 25,color: scheme.surface,),
               selectedIcon: Icon(Ionicons.home_sharp,size: 25,color: scheme.surface,),
               label: 'Home'),
          NavigationDestination(
              icon: Icon(Ionicons.pie_chart_outline,size: 25,color: scheme.surface,),
              selectedIcon: Icon(Ionicons.pie_chart_sharp,size: 25,color: scheme.surface,),
              label: 'Statistics'),
          NavigationDestination(
              icon: Icon(Ionicons.settings_outline,size: 25,color: scheme.surface,),
              selectedIcon: Icon(Ionicons.settings_sharp,size: 25,color: scheme.surface,),
              label: 'Settings'),
        ],

      ),
    );
  }
}
