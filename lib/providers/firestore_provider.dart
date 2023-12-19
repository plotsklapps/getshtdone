// Provider for the Firebase Firestore instance.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider for the Firebase Firestore instance.
final Provider<FirebaseFirestore> firestoreProvider =
    Provider<FirebaseFirestore>((ProviderRef<FirebaseFirestore> ref) {
  return FirebaseFirestore.instance;
});
