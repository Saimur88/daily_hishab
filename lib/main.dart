import 'package:daily_hishab/providers/transaction_provider.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app/router/app_router.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TransactionProvider()),
      ],
      child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: FlexThemeData.light(
        scheme: FlexScheme.blue,
        useMaterial3: true,
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
