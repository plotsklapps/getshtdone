import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getsh_tdone/models/todo_model.dart';
import 'package:getsh_tdone/providers/firestore_provider.dart';
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
    final User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null && currentUser.emailVerified) {
      todoSubscription = ref
          .read(firestoreProvider)
          .collection('users')
          .doc(currentUser.uid)
          .collection('todoCollection')
          .snapshots()
          .listen(
        (QuerySnapshot<Map<String, dynamic>> snapshot) {
          final List<Todo> todos = snapshot.docs
              .map((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
            return Todo.fromSnapshot(doc);
          }).toList();
          state = AsyncValue<List<Todo>>.data(todos);
        },
        onError: (Object error, StackTrace stackTrace) {
          state = AsyncValue<List<Todo>>.error(error, stackTrace);
        },
      );
    } else {
      state = const AsyncValue<List<Todo>>.data(<Todo>[]);
    }
  }
}
