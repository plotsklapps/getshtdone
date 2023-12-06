import 'package:flutter_riverpod/flutter_riverpod.dart';

final StateProvider<String> titleProvider =
    StateProvider<String>((StateProviderRef<String> ref) {
  return '';
});
