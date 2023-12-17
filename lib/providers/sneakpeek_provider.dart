import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider to check if the user is a Sneak Peeker, initially returns false.
final StateProvider<bool> isSneakPeekerProvider =
    StateProvider<bool>((StateProviderRef<bool> ref) {
  return false;
});
