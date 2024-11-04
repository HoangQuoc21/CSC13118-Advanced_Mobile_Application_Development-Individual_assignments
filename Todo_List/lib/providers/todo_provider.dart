import 'package:flutter/material.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/services/local_storage_service.dart';

class TodoProvider with ChangeNotifier {
  List<Todo> _todos = [];
  final LocalStorageService _localStorageService = LocalStorageService();

  List<Todo> get todos => _todos;

  TodoProvider() {
    _init();
  }

  Future<void> _init() async {
    await _localStorageService.init();
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    _todos = await _localStorageService.loadTodos();
    notifyListeners();
  }

  Future<void> _saveTodoToDatabase(Todo todo) async {
    await _localStorageService.saveTodoToDatabase(todo);
  }

  Future<void> _deleteTodoFromDatabase(String id) async {
    await _localStorageService.deleteTodoFromDatabase(id);
  }

  void addTodo(Todo todo) {
    _todos.add(todo);
    _saveTodoToDatabase(todo);
    notifyListeners();
  }

  void updateTodo(Todo todo) {
    int index = _todos.indexWhere((t) => t.id == todo.id);
    if (index != -1) {
      _todos[index] = todo;
      _saveTodoToDatabase(todo);
      notifyListeners();
    }
  }

  void deleteTodo(String id) {
    _todos.removeWhere((todo) => todo.id == id);
    _deleteTodoFromDatabase(id);
    notifyListeners();
  }
}
