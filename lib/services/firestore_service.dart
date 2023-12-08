import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getsh_tdone/models/todo_model.dart';
import 'package:getsh_tdone/providers/firebase_provider.dart';
import 'package:getsh_tdone/providers/firestore_provider.dart';

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
        .add(
          newTodo.toMap(),
        );
  }

  Future<void> updateTodo(Todo todo) async {
    final User? currentUser = ref.read(firebaseProvider).currentUser;
    await ref
        .read(firestoreProvider)
        .collection('users')
        .doc(currentUser?.uid)
        .collection('todoCollection')
        .doc(todo.id)
        .update(
          todo.toMap(),
        );
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

  Future<List<Todo>> getTodos() async {
    final User? currentUser = ref.read(firebaseProvider).currentUser;
    final QuerySnapshot<Map<String, dynamic>> snapshot = await ref
        .read(firestoreProvider)
        .collection('users')
        .doc(currentUser?.uid)
        .collection('todoCollection')
        .get();
    return snapshot.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
      return Todo.fromSnapshot(doc);
    }).toList();
  }
}
