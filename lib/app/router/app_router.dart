import 'package:go_router/go_router.dart';
import '../../screens/home_screen.dart';

final appRouter = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        name: 'home',
        path: '/',
        builder: (context, state) => const HomeScreen(),)
    ] );