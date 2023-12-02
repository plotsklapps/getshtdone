import 'package:signals/signals.dart';

class Todo {
  Todo({
    required this.title,
    required this.description,
    this.isDone = false,
  });
  final String title;
  final String description;
  bool isDone;

  Todo copyWith({
    String? title,
    String? description,
    bool? isDone,
  }) {
    return Todo(
      title: title ?? this.title,
      description: description ?? this.description,
      isDone: isDone ?? this.isDone,
    );
  }

  @override
  String toString() {
    return 'Todo{title: $title, description: $description, isDone: $isDone}';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Todo &&
            runtimeType == other.runtimeType &&
            title == other.title &&
            description == other.description &&
            isDone == other.isDone;
  }

  @override
  int get hashCode {
    return title.hashCode ^ description.hashCode ^ isDone.hashCode;
  }
}

final todoStore = TodoStore();

class TodoStore {
  final todosList = <Todo>[].toSignal();

  void addTodo(Todo newTodo) {
    todosList.value = [...todosList.value, newTodo];
  }

  void removeTodo(Todo removedTodo) {
    todosList.value = todosList.value.where((t) {
      return t != removedTodo;
    }).toList();
  }

  void doneTodo(Todo doneTodo) {
    todosList.value = todosList.value.map((t) {
      if (t == doneTodo) {
        return t.copyWith(isDone: !t.isDone);
      }
      return t;
    }).toList();
  }
}
