import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

// Create a Uuid instance to generate unique id's for each new task.
Uuid uuid = const Uuid();

class Todo {
  String? id;
  final String title;
  String? description;
  String? category;
  String? dueDate;
  String? dueTime;
  bool isCompleted = false;

  // Constructor for the task class.
  // If an ID is not provided, a new UUID is generated
  Todo({
    required this.title,
    required this.isCompleted,
    this.description,
    this.category,
    this.dueDate,
    this.dueTime,
    String? id,
  }) : id = id ?? uuid.v4();

  // Create a new task object that is a COPY of the current task object, but
  // with some fields potentially replaced with new values.
  Todo copyWith({
    String? title,
    String? description,
    String? category,
    String? dueDate,
    String? dueTime,
    bool? isCompleted,
  }) {
    return Todo(
      id: id, // Keep the same id
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      dueDate: dueDate ?? this.dueDate,
      dueTime: dueTime ?? this.dueTime,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  // Method to convert a task object to a Map.
  // This is useful when storing the task to Firestore.
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

  // Method to create a new task object from a Firestore DocumentSnapshot.
  // This is useful when retrieving the task from Firestore.
  factory Todo.fromSnapshot(DocumentSnapshot<Object?> doc) {
    return Todo(
      id: doc.id,
      title: doc['title'] as String,
      description: doc['description'] as String?,
      category: doc['category'] as String?,
      dueDate: doc['dueDate'] as String?,
      dueTime: doc['dueTime'] as String?,
      isCompleted: doc['isCompleted'] as bool? ?? false,
    );
  }
}
