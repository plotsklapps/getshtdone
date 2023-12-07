import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getsh_tdone/providers/firebase_provider.dart';
import 'package:getsh_tdone/providers/smiley_provider.dart';

// Provider for the avatar picture, initially returns a standard png.
final AutoDisposeStateProvider<String> photoURLProvider =
    StateProvider.autoDispose<String>((StateProviderRef<String> ref) {
  final String smiley = ref.watch(smileyProvider);
  final User? user = ref.watch(firebaseProvider).currentUser;
  if (user != null) {
    // Fetch the photoURL from Firebase Auth.
    final String photoURL = user.photoURL!;
    return photoURL;
  } else {
    return smiley;
  }
});
