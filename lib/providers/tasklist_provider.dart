import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getsh_tdone/models/task_model.dart';
import 'package:getsh_tdone/providers/category_provider.dart';
import 'package:getsh_tdone/providers/firestore_provider.dart';
import 'package:getsh_tdone/providers/sortingmethod_provider.dart';
import 'package:getsh_tdone/services/logger.dart';

final StateNotifierProvider<TaskListNotifier, AsyncValue<List<Task>>>
    taskListProvider =
    StateNotifierProvider<TaskListNotifier, AsyncValue<List<Task>>>(
  (StateNotifierProviderRef<TaskListNotifier, AsyncValue<List<Task>>> ref) {
    return TaskListNotifier(ref);
  },
);

class TaskListNotifier extends StateNotifier<AsyncValue<List<Task>>> {
  TaskListNotifier(this.ref) : super(const AsyncValue<List<Task>>.loading()) {
    fetchTasks();
    ref.onDispose(() {
      taskSubscription?.cancel();
    });
  }

  final StateNotifierProviderRef<TaskListNotifier, AsyncValue<List<Task>>> ref;
  StreamSubscription<QuerySnapshot<Object?>>? taskSubscription;

  void toggleCompleted(String id) {
    state.whenData((List<Task> tasks) {
      state = AsyncValue<List<Task>>.data(
        tasks.map((Task task) {
          if (task.id == id) {
            final Task updatedTask =
                task.copyWith(isCompleted: !task.isCompleted);
            final User? currentUser = FirebaseAuth.instance.currentUser;
            if (currentUser != null && currentUser.emailVerified) {
              try {
                ref
                    .read(firestoreProvider)
                    .collection('users')
                    .doc(currentUser.uid)
                    .collection('taskCollection')
                    .doc(id)
                    .update(updatedTask.toMap());
                Logs.toggleTaskComplete();
              } catch (error) {
                Logs.toggleTaskFailed();
              }
            }
            return updatedTask;
          } else {
            return task;
          }
        }).toList(),
      );
    });
  }

  void fetchTasks() {
    // Get the current user from Firebase Auth.
    final User? currentUser = FirebaseAuth.instance.currentUser;

    // Get the current sorting method from the sortingMethodProvider.
    final String sortingMethod = ref.watch(sortByDateProvider);

    // Get the current sort order from the sortOrderProvider.
    final bool isDescending = ref.watch(isDescendingProvider);

    // Get the current category from the categoryStringProvider.
    final String category = ref.watch(categoryStringProvider);

    // Check if the user is logged in and their email is verified.
    if (currentUser != null && currentUser.emailVerified) {
      // Start building the Firestore query
      Query<Map<String, dynamic>> query = ref
          .read(firestoreProvider)
          .collection('users')
          .doc(currentUser.uid)
          .collection('taskCollection');

      // If the category is not 'All', filter the tasks by that category.
      if (category != 'all') {
        query = query.where('category', isEqualTo: category);
      }

      // If the sorting method is 'dueDate' or 'creationDate', sort the tasks
      // by that field.
      if (sortingMethod == 'dueDate' || sortingMethod == 'createdDate') {
        query = query.orderBy(sortingMethod, descending: isDescending);
      }

      // Listen to the Firestore query and update the state whenever the query
      // results change.
      taskSubscription = query.snapshots().listen(
        (QuerySnapshot<Map<String, dynamic>> snapshot) {
          // Map the Firestore documents to Task objects
          final List<Task> tasks = snapshot.docs
              .map((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
            return Task.fromSnapshot(doc);
          }).toList();

          // Update the state with the filtered and sorted tasks
          state = AsyncValue<List<Task>>.data(tasks);
        },
        onError: (Object error, StackTrace stackTrace) {
          // If there's an error, update the state with the error
          state = AsyncValue<List<Task>>.error(error, stackTrace);
        },
      );
    } else {
      // If the user is not logged in or their email is not verified,
      // update the state with an empty list of tasks.
      state = const AsyncValue<List<Task>>.data(<Task>[]);
    }
  }

  void cancelSubscription() {
    taskSubscription?.cancel();
  }
}
