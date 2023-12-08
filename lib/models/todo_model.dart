import 'package:uuid/uuid.dart';

Uuid uuid = const Uuid();

class Todo {
  Todo({
    required this.title,
    required this.isCompleted,
    this.description,
    this.category,
    this.dueDate,
    this.dueTime,
    String? id,
  }) : id = id ?? uuid.v4();

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'] as String?,
      title: map['title'] as String,
      description: map['description'] as String?,
      category: map['category'] as String?,
      dueDate: map['dueDate'] as String?,
      dueTime: map['dueTime'] as String?,
      isCompleted: map['isCompleted'] as bool? ?? false,
    );
  }

  factory Todo.fromSnapshot(dynamic doc) {
    return Todo(
      id: doc.id as String?,
      title: doc['title'] as String,
      description: doc['description'] as String?,
      category: doc['category'] as String?,
      dueDate: doc['dueDate'] as String?,
      dueTime: doc['dueTime'] as String?,
      isCompleted: doc['isCompleted'] as bool? ?? false,
    );
  }
  String? id;
  final String title;
  String? description;
  String? category;
  String? dueDate;
  String? dueTime;
  bool isCompleted = false;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'dueDate': dueDate,
      'dueTime': dueTime,
      'isCompleted': isCompleted,
    };
  }

  @override
  String toString() {
    return 'Todo{id: $id, title: $title, description: $description, '
        'category: $category, dueDate: $dueDate, dueTime: $dueTime, '
        'isCompleted: $isCompleted,}';
  }
}