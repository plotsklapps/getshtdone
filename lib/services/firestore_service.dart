import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getsh_tdone/models/task_model.dart';
import 'package:getsh_tdone/providers/firebase_provider.dart';
import 'package:getsh_tdone/providers/firestore_provider.dart';
import 'package:getsh_tdone/providers/issearchperformed_provider.dart';
import 'package:logger/logger.dart';

class FirestoreService {
  FirestoreService(this.ref);

  final WidgetRef ref;

  Future<void> addTask(Task newTask) async {
    // Fetch the current user.
    final User? currentUser = ref.read(firebaseProvider).currentUser;
    // Store the new task in the Firestore database.
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
    // Fetch the current user.
    final User? currentUser = ref.read(firebaseProvider).currentUser;

    // Get a reference to the document in Firestore that corresponds to the
    // task.
    final DocumentReference<Map<String, dynamic>> docRef = ref
        .read(firestoreProvider)
        .collection('users')
        .doc(currentUser?.uid)
        .collection('taskCollection')
        .doc(task.id);

    // Fetch the specific document from Firestore.
    final DocumentSnapshot<Map<String, dynamic>> docSnapshot =
        await docRef.get();

    // Check if the document exists in Firestore.
    if (docSnapshot.exists) {
      // If the document exists, update it with the new task data.
      await docRef.update(
        task.toMap(),
      );
    } else {
      // TODO(plotsklapps): Handle this error.
      Logger().w('Document does not exist on the database');
    }
  }

  Future<void> deleteTask(String id) async {
    // Fetch the current user.
    final User? currentUser = ref.read(firebaseProvider).currentUser;
    // Delete the task from the Firestore database, using the id to identify
    // the task.
    await ref
        .read(firestoreProvider)
        .collection('users')
        .doc(currentUser?.uid)
        .collection('taskCollection')
        .doc(id)
        .delete();
  }

  Future<List<Task>> searchTask(String keyword) async {
    // Fetch the current user.
    final User? currentUser = ref.read(firebaseProvider).currentUser;
    // Set the isSearchPerformed state to true (used to display the iconbutton
    // in the appbar).
    ref.read(isSearchPerformedProvider.notifier).state = true;
    // Get a reference to the collection of tasks in Firestore.
    final CollectionReference<Map<String, dynamic>> taskCollection = ref
        .read(firestoreProvider)
        .collection('users')
        .doc(currentUser?.uid)
        .collection('taskCollection');

    // Fetch the documents from Firestore.
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await taskCollection.get();

    // Convert the documents to a List of Task objects.
    final List<Task> tasks = querySnapshot.docs.map(Task.fromSnapshot).toList();

    // Filter the tasks that match the keyword, and convert the Iterable to a
    // List while making the title AND the keyword lowercase to make the search
    // case-insensitive.
    final List<Task> matchingTasks = tasks.where((Task task) {
      return task.title.toLowerCase().contains(keyword.toLowerCase());
    }).toList();

    // Return the matching tasks.
    return matchingTasks;
  }
}
