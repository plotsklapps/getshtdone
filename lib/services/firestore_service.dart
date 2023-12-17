import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getsh_tdone/models/task_model.dart';
import 'package:getsh_tdone/providers/firebase_provider.dart';
import 'package:getsh_tdone/providers/firestore_provider.dart';
import 'package:logger/logger.dart';

class FirestoreService {
  FirestoreService(this.ref);

  final WidgetRef ref;

  Future<void> addTask(Task newTask) async {
    final User? currentUser = ref.read(firebaseProvider).currentUser;
    await ref
        .read(firestoreProvider)
        .collection('users')
        .doc(currentUser?.uid)
        .collection('taskCollection')
        .doc(newTask.id)
        .set(
          newTask.toMap(),
        );
  }

  Future<void> updateTask(Task task) async {
    final User? currentUser = ref.read(firebaseProvider).currentUser;
    final DocumentReference<Map<String, dynamic>> docRef = ref
        .read(firestoreProvider)
        .collection('users')
        .doc(currentUser?.uid)
        .collection('taskCollection')
        .doc(task.id);

    final DocumentSnapshot<Map<String, dynamic>> docSnapshot =
        await docRef.get();

    if (docSnapshot.exists) {
      await docRef.update(
        task.toMap(),
      );
    } else {
      Logger().w('Document does not exist on the database');
    }
  }

  Future<void> deleteTask(String id) async {
    final User? currentUser = ref.read(firebaseProvider).currentUser;
    await ref
        .read(firestoreProvider)
        .collection('users')
        .doc(currentUser?.uid)
        .collection('taskCollection')
        .doc(id)
        .delete();
  }
}
