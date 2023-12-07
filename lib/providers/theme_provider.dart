import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final StateProvider<bool> isDarkModeProvider = StateProvider<bool>((
  StateProviderRef<bool> ref,
) {
  return false;
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
