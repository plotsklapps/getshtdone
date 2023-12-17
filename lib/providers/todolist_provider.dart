import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getsh_tdone/models/todo_model.dart';
import 'package:getsh_tdone/providers/category_provider.dart';
import 'package:getsh_tdone/providers/firestore_provider.dart';
import 'package:getsh_tdone/providers/sortingmethod_provider.dart';
import 'package:getsh_tdone/services/logger.dart';

final StateNotifierProvider<TodoListNotifier, AsyncValue<List<Todo>>>
    todoListProvider =
    StateNotifierProvider<TodoListNotifier, AsyncValue<List<Todo>>>(
  (StateNotifierProviderRef<TodoListNotifier, AsyncValue<List<Todo>>> ref) {
    return TodoListNotifier(ref);
  },
);

class TodoListNotifier extends StateNotifier<AsyncValue<List<Todo>>> {
  TodoListNotifier(this.ref) : super(const AsyncValue<List<Todo>>.loading()) {
    fetchTodos();
    ref.onDispose(() {
      todoSubscription?.cancel();
    });
  }

  final StateNotifierProviderRef<TodoListNotifier, AsyncValue<List<Todo>>> ref;
  StreamSubscription<QuerySnapshot<Object?>>? todoSubscription;

  void toggleCompleted(String id) {
    state.whenData((List<Todo> todos) {
      state = AsyncValue<List<Todo>>.data(
        todos.map((Todo todo) {
          if (todo.id == id) {
            final Todo updatedTodo =
                todo.copyWith(isCompleted: !todo.isCompleted);
            final User? currentUser = FirebaseAuth.instance.currentUser;
            if (currentUser != null && currentUser.emailVerified) {
              try {
                ref
                    .read(firestoreProvider)
                    .collection('users')
                    .doc(currentUser.uid)
                    .collection('todoCollection')
                    .doc(id)
                    .update(updatedTodo.toMap());
                Logs.toggleTodoComplete();
              } catch (error) {
                Logs.toggleTodoFailed();
              }
            }
            return updatedTodo;
          } else {
            return todo;
          }
        }).toList(),
      );
    });
  }

  void fetchTodos() {
    // Get the current user from Firebase Auth
    final User? currentUser = FirebaseAuth.instance.currentUser;

    // Get the current sorting method from the sortingMethodProvider
    final String sortingMethod = ref.watch(sortingMethodProvider);

    // Get the current category from the categoryStringProvider
    final String category = ref.watch(categoryStringProvider);

    // Check if the user is logged in and their email is verified
    if (currentUser != null && currentUser.emailVerified) {
      // Start building the Firestore query
      Query<Map<String, dynamic>> query = ref
          .read(firestoreProvider)
          .collection('users')
          .doc(currentUser.uid)
          .collection('todoCollection');

      // If the category is not 'All', filter the todos by that category
      if (category != 'all') {
        query = query.where('category', isEqualTo: category);
      }

      // If the sorting method is 'dueDate' or 'creationDate', sort the todos by that field
      if (sortingMethod == 'dueDate' || sortingMethod == 'creationDate') {
        query = query.orderBy(sortingMethod, descending: false);
      }

      // Listen to the Firestore query and update the state whenever the query results change
      todoSubscription = query.snapshots().listen(
        (QuerySnapshot<Map<String, dynamic>> snapshot) {
          // Map the Firestore documents to Todo objects
          final List<Todo> todos = snapshot.docs
              .map((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
            return Todo.fromSnapshot(doc);
          }).toList();

          // Update the state with the filtered and sorted todos
          state = AsyncValue<List<Todo>>.data(todos);
        },
        onError: (Object error, StackTrace stackTrace) {
          // If there's an error, update the state with the error
          state = AsyncValue<List<Todo>>.error(error, stackTrace);
        },
      );
    } else {
      // If the user is not logged in or their email is not verified, update the state with an empty list of todos
      state = const AsyncValue<List<Todo>>.data(<Todo>[]);
    }
  }

  void cancelSubscription() {
    todoSubscription?.cancel();
  }
}
