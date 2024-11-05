import 'package:todo_list/constants/constants.dart';

class Todo {
  final String id;
  final String title;
  final String description;
  final DateTime? dueTime;
  TodoStatuses status;

  Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    this.dueTime,
  });

  Todo copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueTime,
    TodoStatuses? status,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      dueTime: dueTime ?? this.dueTime,
    );
  }

  bool get isDone => (status == TodoStatuses.completed);
  bool get isDue => (dueTime != null && dueTime!.isBefore(DateTime.now()));

  TodoCategories get category {
    var category = TodoCategories.all;
    if (dueTime != null) {
      var now = DateTime.now();
      var start = DateTime(now.year, now.month, now.day);
      var end = DateTime(now.year, now.month, now.day, 23, 59);
      if (dueTime!.isAfter(start) && dueTime!.isBefore(end)) {
        category = TodoCategories.today;
      } else if (dueTime!.isAfter(end)) {
        category = TodoCategories.upcoming;
      }
    }
    return category;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'dueTime': dueTime?.toIso8601String(),
        'status': status.toString(),
      };

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        status: TodoStatuses.values
            .firstWhere((e) => e.toString() == json['status']),
        dueTime:
            json['dueTime'] != null ? DateTime.parse(json['dueTime']) : null,
      );

  // Convert a Todo into a Map. The keys must correspond to the column names in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueTime': dueTime?.toIso8601String(),
      'status': status.index, // Store the index of the enum
    };
  }

  // Extract a Todo object from a Map.
  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      status: TodoStatuses
          .values[map['status']], // Retrieve the enum from the index
      dueTime: map['dueTime'] != null ? DateTime.parse(map['dueTime']) : null,
    );
  }
}
