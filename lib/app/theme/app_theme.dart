import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light(){
    return FlexThemeData.light(
      scheme: FlexScheme.indigo,
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

    );
  }
}