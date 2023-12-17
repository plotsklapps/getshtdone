import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

// Create a Uuid instance to generate unique id's for each new task.
Uuid uuid = const Uuid();

class Task {
  String? id;
  final String title;
  String? description;
  String? category;
  String? createdDate;
  String? dueDate;
  bool isCompleted = false;

  // Constructor for the task class.
  // If an ID is not provided, a new UUID is generated
  Task({
    required this.title,
    required this.isCompleted,
    this.description,
    this.category,
    this.createdDate,
    this.dueDate,
    String? id,
  }) : id = id ?? uuid.v4();

  // Create a new task object that is a COPY of the current task object, but
  // with some fields potentially replaced with new values.
  Task copyWith({
    String? title,
    String? description,
    String? category,
    String? createdDate,
    String? dueDate,
    bool? isCompleted,
  }) {
    return Task(
      id: id, // Keep the same id
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      createdDate: createdDate ?? this.createdDate,
      dueDate: dueDate ?? this.dueDate,
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
      'createdDate': createdDate,
      'dueDate': dueDate,
      'isCompleted': isCompleted,
    };
  }

  // Method to create a new task object from a Firestore DocumentSnapshot.
  // This is useful when retrieving the task from Firestore.
  factory Task.fromSnapshot(DocumentSnapshot<Object?> doc) {
    return Task(
      id: doc.id,
      title: doc['title'] as String,
      description: doc['description'] as String?,
      category: doc['category'] as String?,
      createdDate: doc['createdDate'] as String?,
      dueDate: doc['dueDate'] as String?,
      isCompleted: doc['isCompleted'] as bool? ?? false,
    );
  }
}
