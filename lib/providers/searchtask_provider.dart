import 'package:flutter_riverpod/flutter_riverpod.dart';

final StateProvider<String> searchTaskProvider =
    StateProvider<String>((StateProviderRef<String> ref) {
  return '';
});
