import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getsh_tdone/providers/firebase_provider.dart';

// Provider for the displayName, initially fetched from Firebase.
final StateProvider<String> displayNameProvider =
    StateProvider<String>((StateProviderRef<String> ref) {
  final User? user = ref.watch(firebaseProvider).currentUser;
  if (user != null && user.displayName != null) {
    // Fetch the displayName from Firebase Auth.
    final String displayName = user.displayName!;
    return displayName;
  } else {
    return 'New User';
  }
});
