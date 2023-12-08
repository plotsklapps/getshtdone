import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getsh_tdone/models/todo_model.dart';
import 'package:getsh_tdone/providers/firebase_provider.dart';
import 'package:getsh_tdone/providers/firestore_provider.dart';

final AutoDisposeStreamProvider<List<Todo>> todoListProvider =
    StreamProvider.autoDispose<List<Todo>>(
        (AutoDisposeStreamProviderRef<List<Todo>> ref) {
  // Trigger a rebuild whenever the FirebaseAuth status changes.
  ref.watch(firebaseUserProvider);

  final User? currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser != null && currentUser.emailVerified) {
    return ref
        .read(firestoreProvider)
        .collection('users')
        .doc(currentUser.uid)
        .collection('todoCollection')
        .snapshots()
        .map((QuerySnapshot<Map<String, dynamic>> snapshot) {
      return snapshot.docs
          .map((QueryDocumentSnapshot<Map<String, dynamic>> snapshot) {
        return Todo.fromSnapshot(snapshot);
      }).toList();
    });
  } else {
    return Stream<List<Todo>>.value(<Todo>[]);
  }
});
