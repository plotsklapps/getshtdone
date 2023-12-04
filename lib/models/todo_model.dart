class Todo {
  Todo({
    required this.title, required this.description, required this.category, required this.date, required this.time, this.uuid,
    this.isCompleted = false,
  });

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      uuid: map['uuid'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      category: map['category'] as int,
      date: map['date'] as String,
      time: map['time'] as String,
      isCompleted: map['isCompleted'] as bool,
    );
  }

  factory Todo.fromSnapshot(String uuid, Map<String, dynamic> map) {
    return Todo(
      uuid: uuid,
      title: map['title'] as String,
      description: map['description'] as String,
      category: map['category'] as int,
      date: map['date'] as String,
      time: map['time'] as String,
      isCompleted: map['isCompleted'] as bool,
    );
  }
  String? uuid;
  final String title;
  final String description;
  final int category;
  final String date;
  final String time;
  bool isCompleted;

  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'title': title,
      'description': description,
      'category': category,
      'date': date,
      'time': time,
      'isCompleted': isCompleted,
    };
  }
}
