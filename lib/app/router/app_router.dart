import 'dart:async';

import 'package:daily_hishab/providers/transaction_provider.dart';
import 'package:daily_hishab/screens/app_shell.dart';
import 'package:daily_hishab/screens/auth/login_screen.dart';
import 'package:daily_hishab/screens/auth/signup_screen.dart';
import 'package:daily_hishab/screens/home_screen.dart';
import 'package:daily_hishab/screens/settings_screen.dart';
import 'package:daily_hishab/screens/statistics_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// Forces GoRouter to re-run `redirect` whenever FirebaseAuth emits a new state.
/// Without this, redirect won't trigger immediately after login/logout (you'll
/// only see the correct screen after app restart).
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _sub = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

final appRouter = GoRouter(
  initialLocation: '/login',

  // Key piece: makes redirects reactive to sign-in/sign-out.
  refreshListenable: GoRouterRefreshStream(
    FirebaseAuth.instance.authStateChanges(),
  ),

  redirect: (context, state) {
    final user = FirebaseAuth.instance.currentUser;
    final loggedIn = user != null;

    final loc = state.matchedLocation;

    final goingToLogin = loc == '/login';
    final goingToSignup = loc == '/signup';
    final inAuthFlow = goingToLogin || goingToSignup;

    // Not logged in -> force auth flow
    if (!loggedIn) {
      return inAuthFlow ? null : '/login';
    }

    // Logged in -> prevent access to auth flow
    if (loggedIn && inAuthFlow) {
      return '/home';
    }

    // Otherwise allow navigation
    return null;
  },

  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignupScreen(),
    ),

    StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => ChangeNotifierProvider(
                  create: (_) => TransactionProvider(),
                  child: const HomeScreen()),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/statistics',
              builder: (context, state) => const StatisticsScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsScreen(),
            ),
          ]),


        ]),
  ],
);