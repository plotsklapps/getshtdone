import 'package:flutter_riverpod/flutter_riverpod.dart';

final StateProvider<bool> isSearchPerformedProvider =
    StateProvider<bool>((StateProviderRef<bool> ref) {
  return false;
});
