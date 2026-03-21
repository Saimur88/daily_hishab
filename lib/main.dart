import 'package:daily_hishab/services/auth_service.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app/router/app_router.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

final AuthService authService = AuthService();


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: WidgetsBinding.instance);
  await Firebase.initializeApp();
  await authService.initialize();

  FlutterNativeSplash.remove();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: FlexThemeData.light(
        colors: const FlexSchemeColor(
          primary: Color(0xFFffaa82), // Deep Indigo
          error: Color(0xffef233c),
          primaryContainer: Color(0xFFC5CAE9), // Light Indigo
          secondary: Color(0xFFffdecf),     // Success/Growth Green
          secondaryContainer: Color(0xFFB9F6CA),
          tertiary: Color(0xFFFFAB00),         // Amber for warnings/pending
          appBarColor: Color(0xFF1A237E),
        ),
        surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
        blendLevel: 20,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 10,
          blendOnColors: false,
          useMaterial3Typography: true,
          useM2StyleDividerInM3: true,
          filledButtonRadius: 12,
          elevatedButtonRadius: 12,
          outlinedButtonRadius: 12,
          cardRadius: 16,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
      ),
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,

    );
  }
}
