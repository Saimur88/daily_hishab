import 'package:daily_hishab/screens/auth/auth_gate.dart';
import 'package:daily_hishab/screens/home_screen.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        name: 'root',
        path: '/',
        builder: (context, state) => const AuthGate(),)
    ] );