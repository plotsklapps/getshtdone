import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final isDarkModeProvider = StateProvider<bool>((ref) {
  return true;
});

final themeModeProvider = StateProvider<ThemeMode>((ref) {
  if (ref.watch(isDarkModeProvider)) {
    return ThemeMode.dark;
  } else {
    return ThemeMode.light;
  }
});
