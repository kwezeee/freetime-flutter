import 'package:flutter/material.dart';
import 'package:figma_squircle/figma_squircle.dart';


/// ------------------------------------------------------------
/// AppTheme – global M3 theme with iOS / Android native motions
/// ------------------------------------------------------------
class AppTheme {
  static const Color _seed = Color(0xFF0055FE);
  static final  _radius = SmoothBorderRadius(cornerRadius: 12, cornerSmoothing: 0.6);

  static SmoothBorderRadius get radius => _radius;

  static ThemeData build([Brightness brightness = Brightness.light]) {
    final scheme = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: brightness,
    );
    return ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
      scaffoldBackgroundColor:
      brightness == Brightness.light ? Colors.grey[50] : Colors.black,
      inputDecorationTheme: _inputDecoration(scheme),
      elevatedButtonTheme: _buttonTheme(scheme),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
        },
      ),
    );
  }

  static InputDecorationTheme _inputDecoration(ColorScheme scheme) {
    return InputDecorationTheme(
      filled: true,
      fillColor: scheme.onSurface.withAlpha(20),
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: TextStyle(color: scheme.onSurface.withAlpha(140)),
    );
  }

  static ElevatedButtonThemeData _buttonTheme(ColorScheme scheme) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: scheme.primary,
        disabledBackgroundColor: scheme.primary.withAlpha(60),
        shadowColor: scheme.primary.withAlpha(80),
        elevation: 4,
        shape: SmoothRectangleBorder(borderRadius: _radius),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}