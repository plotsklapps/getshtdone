import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getsh_tdone/models/task_model.dart';
import 'package:getsh_tdone/providers/category_provider.dart';
import 'package:getsh_tdone/providers/firestore_provider.dart';
import 'package:getsh_tdone/providers/sortingmethod_provider.dart';
import 'package:getsh_tdone/services/logger.dart';

// The taskListProvider is a provider that manages a list of Task objects.
// It can be in a loading state, a data state with a list of tasks, or an
// error state. The state is controlled by the TaskListNotifier, which can
// read other providers and update the state.
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
      // The state is updated with a new AsyncValue that contains a list of
      // tasks.
      state = AsyncValue<List<Task>>.data(
        // The tasks are mapped to create a new list.
        tasks.map((Task task) {
          // If the task id matches the provided id, the task is updated.
          if (task.id == id) {
            // A new task is created with the isCompleted property toggled.
            final Task updatedTask =
                task.copyWith(isCompleted: !task.isCompleted);
            // The current user is retrieved from Firebase Auth.
            final User? currentUser = FirebaseAuth.instance.currentUser;
            // If the user is not null and their email is verified, the task
            // is updated in Firestore.
            if (currentUser != null && currentUser.emailVerified) {
              try {
                // The task document in Firestore is updated with the new
                // task data.
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
            // The updated task is returned to be included in the new task list.
            return updatedTask;
          } else {
            // If the task id doesn't match the provided id, the original task
            // is returned.
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
      // Start building the Firestore query.
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
          // Map the Firestore documents to Task objects.
          final List<Task> tasks = snapshot.docs
              .map((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
            return Task.fromSnapshot(doc);
          }).toList();

          // Update the state with the filtered and sorted tasks.
          state = AsyncValue<List<Task>>.data(tasks);
        },
        onError: (Object error, StackTrace stackTrace) {
          // If there's an error, update the state with the error.
          state = AsyncValue<List<Task>>.error(error, stackTrace);
        },
      );
    } else {
      // If the user is not logged in or their email is not verified,
      // update the state with an empty list of tasks.
      state = const AsyncValue<List<Task>>.data(<Task>[]);
    }
  }

  // There needs to be a way to cancel the Firestore subscription when the
  // provider is disposed. This method cancels the subscription.
  void cancelSubscription() {
    taskSubscription?.cancel();
  }
}
