import 'package:flutter_riverpod/flutter_riverpod.dart';

final StateProvider<String> sortingMethodProvider =
    StateProvider<String>((StateProviderRef<String> ref) {
  return 'dueDate';
});
