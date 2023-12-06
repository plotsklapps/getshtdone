import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getsh_tdone/models/todo_model.dart';
import 'package:getsh_tdone/providers/firebase_provider.dart';

// Provider for the Firebase Firestore instance.
final Provider<FirebaseFirestore> firestoreProvider =
    Provider<FirebaseFirestore>((ProviderRef<FirebaseFirestore> ref) {
  return FirebaseFirestore.instance;
});

final AutoDisposeStreamProvider<List<Todo>> todoListProvider =
    StreamProvider.autoDispose<List<Todo>>(
  (AutoDisposeStreamProviderRef<List<Todo>> ref) async* {
    final User? currentUser = ref.watch(firebaseProvider).currentUser;
    final Stream<List<Todo>> getAllTodos = ref
        .read(firestoreProvider)
        .collection('users')
        .doc(currentUser?.uid)
        .collection('todoCollection')
        .snapshots()
        .map((QuerySnapshot<Map<String, dynamic>> event) {
      return event.docs
          .map((QueryDocumentSnapshot<Map<String, dynamic>> snapshot) {
        return Todo.fromSnapshot(snapshot);
      }).toList();
    });
    yield* getAllTodos;
  },
);

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
