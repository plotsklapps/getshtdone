import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final StateProvider<bool> isDarkModeProvider = StateProvider<bool>((
  StateProviderRef<bool> ref,
) {
  return false;
});

final StateProvider<bool> isGreenSchemeProvider =
    StateProvider<bool>((StateProviderRef<bool> ref) {
  return true;
});

final StateProvider<ThemeMode> themeModeProvider = StateProvider<ThemeMode>((
  StateProviderRef<ThemeMode> ref,
) {
  if (ref.watch(isDarkModeProvider)) {
    return ThemeMode.dark;
  } else {
    return ThemeMode.light;
  }
});

final StateProvider<FlexScheme> flexSchemeProvider =
    StateProvider<FlexScheme>((StateProviderRef<FlexScheme> ref) {
  if (ref.watch(isGreenSchemeProvider)) {
    return FlexScheme.money;
  } else {
    return FlexScheme.espresso;
  }
});
