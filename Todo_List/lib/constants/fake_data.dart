import 'package:todo_list/models/todo.dart';
//import 'package:todo_list/constants/todo_categories.dart';
import 'package:todo_list/constants/todo_statuses.dart';

final List<Todo> todos = [
  Todo(
    title: 'Buy groceries',
    description: 'Milk, Cheese, Pizza, Fruit, Fish',
    status: TodoStatuses.pending,
    // Generate a today due time
    dueTime: DateTime.now().add(Duration(hours: 1, minutes: 00)),
  ),
  Todo(
    title: 'Send email',
    description: 'Send email to John Doe',
    status: TodoStatuses.pending,
    // Generate a due time at 9:00 AM 21/10/2024
    dueTime: DateTime(2024, 10, 21, 9, 0),
  ),
  Todo(
    title: 'Plan weekend',
    description: 'Go out with friends',
    status: TodoStatuses.pending,
    // Generate a due time at 9:00 AM 21/10/2025
    dueTime: DateTime(2025, 10, 21, 9, 0),
  ),
];
