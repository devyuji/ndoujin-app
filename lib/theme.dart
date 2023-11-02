import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import "package:material_color_utilities/material_color_utilities.dart";
import 'package:ndoujin/model/theme.dart';

class NoAnimationPageTransitionsBuilder extends PageTransitionsBuilder {
  const NoAnimationPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}

class ThemeProvider {
  const ThemeProvider({
    Key? key,
    required this.settings,
    this.darkDynamic,
  });

  final ThemeSettings settings;
  final ColorScheme? darkDynamic;

  final pageTransitionsTheme = const PageTransitionsTheme(
    builders: <TargetPlatform, PageTransitionsBuilder>{
      TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      TargetPlatform.linux: NoAnimationPageTransitionsBuilder(),
      TargetPlatform.macOS: NoAnimationPageTransitionsBuilder(),
      TargetPlatform.windows: NoAnimationPageTransitionsBuilder(),
    },
  );

  Color blend(Color targetColor) {
    return Color(
        Blend.harmonize(targetColor.value, settings.sourceColor.value));
  }

  Color source(Color? target) {
    Color source = settings.sourceColor;
    if (target != null) {
      source = blend(target);
    }
    return source;
  }

  ColorScheme colors(Brightness brightness, Color? targetColor) {
    final darkPrimary = darkDynamic?.primary;

    return ColorScheme.fromSeed(
      seedColor: darkPrimary ?? source(targetColor),
      brightness: brightness,
    );
  }

  ShapeBorder get shapeMedium => RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      );

  ListTileThemeData listTileTheme(ColorScheme colors) {
    return ListTileThemeData(
      shape: shapeMedium,
      selectedColor: colors.secondary,
    );
  }

  AppBarTheme appBarTheme(ColorScheme colors) {
    return AppBarTheme(
      elevation: 0,
      backgroundColor: colors.surface,
      foregroundColor: colors.onSurface,
      titleTextStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 30,
      ),
    );
  }

  ThemeData dark([Color? targetColor]) {
    final color = colors(Brightness.dark, targetColor);
    return ThemeData.dark().copyWith(
      pageTransitionsTheme: pageTransitionsTheme,
      colorScheme: color,
      appBarTheme: appBarTheme(color),
      listTileTheme: listTileTheme(color),
      scaffoldBackgroundColor: color.background,
      useMaterial3: true,
      textTheme: GoogleFonts.montserratTextTheme(
        const TextTheme(
          bodyLarge: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
