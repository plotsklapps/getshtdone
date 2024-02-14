import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getsh_tdone/providers/theme_provider.dart';
import 'package:google_fonts/google_fonts.dart';

// Theme config for FlexColorScheme version 7.3.x. Make sure you use
// same or higher package version, but still same major version. If you
// use a lower package version, some properties may not be supported.
// In that case remove them after copying this theme to your app.

ThemeData themeLight(WidgetRef ref) {
  final FlexScheme flexScheme = ref.watch(flexSchemeProvider);
  return FlexThemeData.light(
    scheme: flexScheme,
    surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
    blendLevel: 18,
    appBarElevation: 4.0,
    bottomAppBarElevation: 4.0,
    subThemesData: const FlexSubThemesData(
      blendOnLevel: 12,
      blendOnColors: false,
      blendTextTheme: true,
      useTextTheme: true,
      thinBorderWidth: 2.0,
      thickBorderWidth: 4.0,
      splashType: FlexSplashType.defaultSplash,
      defaultRadius: 12.0,
      unselectedToggleIsColored: true,
      sliderValueTinted: true,
      sliderTrackHeight: 5,
      inputDecoratorBorderType: FlexInputBorderType.underline,
      inputDecoratorUnfocusedBorderIsColored: false,
      fabUseShape: true,
      fabAlwaysCircular: true,
      popupMenuRadius: 12.0,
      popupMenuElevation: 4.0,
      alignedDropdown: true,
      tooltipRadius: 12,
      dialogElevation: 4.0,
      timePickerElementRadius: 12.0,
      useInputDecoratorThemeInDialogs: true,
      snackBarRadius: 12,
      snackBarElevation: 4,
      appBarScrolledUnderElevation: 4.0,
      tabBarIndicatorWeight: 4,
      tabBarIndicatorTopRadius: 8,
      drawerElevation: 4.0,
      drawerWidth: 300.0,
      bottomSheetElevation: 4.0,
      bottomSheetModalElevation: 4.0,
      bottomNavigationBarElevation: 4.0,
      menuRadius: 12.0,
      menuElevation: 4.0,
      menuBarRadius: 12.0,
      menuBarElevation: 4.0,
      menuIndicatorRadius: 12.0,
      navigationBarElevation: 4.0,
      navigationBarHeight: 64.0,
      navigationRailElevation: 4.0,
    ),
    keyColors: const FlexKeyColors(
      useSecondary: true,
    ),
    tones: FlexTones.chroma(Brightness.light),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    useMaterial3: true,
    swapLegacyOnMaterial3: true,
// To use the Playground font, add GoogleFonts package and uncomment
    fontFamily: GoogleFonts.teko().fontFamily,
  );
}

ThemeData themeDark(WidgetRef ref) {
  final FlexScheme flexScheme = ref.watch(flexSchemeProvider);
  return FlexThemeData.dark(
    scheme: flexScheme,
    surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
    blendLevel: 20,
    appBarElevation: 4.0,
    bottomAppBarElevation: 4.0,
    subThemesData: const FlexSubThemesData(
      blendOnLevel: 20,
      blendTextTheme: true,
      useTextTheme: true,
      splashType: FlexSplashType.defaultSplash,
      defaultRadius: 12.0,
      thinBorderWidth: 2.0,
      thickBorderWidth: 4.0,
      unselectedToggleIsColored: true,
      sliderValueTinted: true,
      sliderTrackHeight: 5,
      inputDecoratorBorderType: FlexInputBorderType.underline,
      inputDecoratorUnfocusedBorderIsColored: false,
      fabUseShape: true,
      fabAlwaysCircular: true,
      popupMenuRadius: 12.0,
      popupMenuElevation: 4.0,
      alignedDropdown: true,
      tooltipRadius: 12,
      dialogElevation: 4.0,
      timePickerElementRadius: 12.0,
      useInputDecoratorThemeInDialogs: true,
      snackBarRadius: 12,
      snackBarElevation: 4,
      appBarScrolledUnderElevation: 4.0,
      tabBarIndicatorWeight: 4,
      tabBarIndicatorTopRadius: 8,
      drawerElevation: 4.0,
      drawerWidth: 300.0,
      bottomSheetElevation: 4.0,
      bottomSheetModalElevation: 4.0,
      bottomNavigationBarElevation: 4.0,
      menuRadius: 12.0,
      menuElevation: 4.0,
      menuBarRadius: 12.0,
      menuBarElevation: 4.0,
      menuIndicatorRadius: 12.0,
      navigationBarElevation: 4.0,
      navigationBarHeight: 64.0,
      navigationRailElevation: 4.0,
    ),
    keyColors: const FlexKeyColors(
      useSecondary: true,
    ),
    tones: FlexTones.chroma(Brightness.dark),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    useMaterial3: true,
    swapLegacyOnMaterial3: true,
    fontFamily: GoogleFonts.teko().fontFamily,
  );
}

// Light and dark ColorSchemes made by FlexColorScheme v7.3.1.
// These ColorScheme objects require Flutter 3.7 or later.
ColorScheme flexSchemeLight(WidgetRef ref) {
  final bool isGreenScheme = ref.watch(isGreenSchemeProvider);
  if (isGreenScheme) {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff3f674d),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffa5d1b1),
      onPrimaryContainer: Color(0xff001207),
      secondary: Color(0xff929460),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffebecb0),
      onSecondaryContainer: Color(0xff1c1d00),
      tertiary: Color(0xff4e7e8c),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffdaf5ff),
      onTertiaryContainer: Color(0xff00161c),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff410002),
      background: Color(0xffedeeea),
      onBackground: Color(0xff131412),
      surface: Color(0xffedeeea),
      onSurface: Color(0xff131412),
      surfaceVariant: Color(0xffdbdfd9),
      onSurfaceVariant: Color(0xff191c1a),
      outline: Color(0xff454744),
      outlineVariant: Color(0xffaaaca8),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff313431),
      onInverseSurface: Color(0xfffbf9f6),
      inversePrimary: Color(0xffc0edcc),
      surfaceTint: Color(0xff3f674d),
    );
  } else {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff725853),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffe1bfb9),
      onPrimaryContainer: Color(0xff1a0a07),
      secondary: Color(0xff9a9074),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xfff3e7c8),
      onSecondaryContainer: Color(0xff211b08),
      tertiary: Color(0xff82765d),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffffefd1),
      onTertiaryContainer: Color(0xff191203),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff410002),
      background: Color(0xfff5ecea),
      onBackground: Color(0xff161312),
      surface: Color(0xfff5ecea),
      onSurface: Color(0xff161312),
      surfaceVariant: Color(0xffe9dbd8),
      onSurfaceVariant: Color(0xff201a19),
      outline: Color(0xff4d4543),
      outlineVariant: Color(0xffb4a9a7),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff373131),
      onInverseSurface: Color(0xfffff8f6),
      inversePrimary: Color(0xfffedbd4),
      surfaceTint: Color(0xff725853),
    );
  }
}

ColorScheme flexSchemeDark(WidgetRef ref) {
  final bool isGreenScheme = ref.watch(isGreenSchemeProvider);
  if (isGreenScheme) {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffa5d1b1),
      onPrimary: Color(0xff002613),
      primaryContainer: Color(0xff3f674d),
      onPrimaryContainer: Color(0xffddffe4),
      secondary: Color(0xffadaf78),
      onSecondary: Color(0xff0e0f00),
      secondaryContainer: Color(0xff787a48),
      onSecondaryContainer: Color(0xfff6f7bb),
      tertiary: Color(0xffb1e2f2),
      onTertiary: Color(0xff001319),
      tertiaryContainer: Color(0xff184d5a),
      onTertiaryContainer: Color(0xffc1f0ff),
      error: Color(0xffffb4ab),
      onError: Color(0xff310001),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffedea),
      background: Color(0xff1d221e),
      onBackground: Color(0xfff1f1ed),
      surface: Color(0xff171b18),
      onSurface: Color(0xfff1f1ed),
      surfaceVariant: Color(0xff303832),
      onSurfaceVariant: Color(0xffdfe4dd),
      outline: Color(0xff8d928c),
      outlineVariant: Color(0xff5a605a),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdfe2dd),
      onInverseSurface: Color(0xff1a1c1a),
      inversePrimary: Color(0xff3f674d),
      surfaceTint: Color(0xffa5d1b1),
    );
  } else {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffe1bfb9),
      onPrimary: Color(0xff2e1b17),
      primaryContainer: Color(0xff725853),
      onPrimaryContainer: Color(0xfffff4f2),
      secondary: Color(0xffb5ab8d),
      onSecondary: Color(0xff120e01),
      secondaryContainer: Color(0xff7f775c),
      onSecondaryContainer: Color(0xfffff3d3),
      tertiary: Color(0xffe8d8bb),
      onTertiary: Color(0xff171002),
      tertiaryContainer: Color(0xff4f4630),
      onTertiaryContainer: Color(0xfff6e7c9),
      error: Color(0xffffb4ab),
      onError: Color(0xff310001),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffedea),
      background: Color(0xff261f1f),
      onBackground: Color(0xfff9eeec),
      surface: Color(0xff1e1818),
      onSurface: Color(0xfff9eeec),
      surfaceVariant: Color(0xff3f3331),
      onSurfaceVariant: Color(0xfff1dfdb),
      outline: Color(0xff9d8d8b),
      outlineVariant: Color(0xff685b59),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffeadedc),
      onInverseSurface: Color(0xff1f1a1a),
      inversePrimary: Color(0xff725853),
      surfaceTint: Color(0xffe1bfb9),
    );
  }
}
