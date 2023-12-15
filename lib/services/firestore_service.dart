import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getsh_tdone/models/todo_model.dart';
import 'package:getsh_tdone/providers/firebase_provider.dart';
import 'package:getsh_tdone/providers/firestore_provider.dart';
import 'package:logger/logger.dart';

class FirestoreService {
  FirestoreService(this.ref);

  final WidgetRef ref;

  Future<void> addTodo(Todo newTodo) async {
    final User? currentUser = ref.read(firebaseProvider).currentUser;
    await ref
        .read(firestoreProvider)
        .collection('users')
        .doc(currentUser?.uid)
        .collection('todoCollection')
        .doc(newTodo.id)
        .set(
          newTodo.toMap(),
        );
  }

  Future<void> updateTodo(Todo todo) async {
    final User? currentUser = ref.read(firebaseProvider).currentUser;
    final DocumentReference<Map<String, dynamic>> docRef = ref
        .read(firestoreProvider)
        .collection('users')
        .doc(currentUser?.uid)
        .collection('todoCollection')
        .doc(todo.id);

    final DocumentSnapshot<Map<String, dynamic>> docSnapshot =
        await docRef.get();

    if (docSnapshot.exists) {
      await docRef.update(
        todo.toMap(),
      );
    } else {
      Logger().w('Document does not exist on the database');
    }
  }

  Future<void> deleteTodo(String id) async {
    final User? currentUser = ref.read(firebaseProvider).currentUser;
    await ref
        .read(firestoreProvider)
        .collection('users')
        .doc(currentUser?.uid)
        .collection('todoCollection')
        .doc(id)
        .delete();
  }
}
