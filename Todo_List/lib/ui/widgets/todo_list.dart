import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/models/models.dart';
import 'package:todo_list/providers/todo_provider.dart';
import 'todo_list_item.dart';
import 'package:todo_list/constants/constants.dart';
import 'package:gap/gap.dart';

class TodoList extends StatefulWidget {
  final TodoCategories category;
  final TodoStatuses? status;
  final String emptyText;
  final String? searchText;
  final bool allowDelete;

  const TodoList({
    required this.category,
    this.status,
    required this.emptyText,
    this.searchText,
    this.allowDelete = false,
    super.key,
  });

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List<Todo> _filterTodos(List<Todo> todos) {
    List<Todo> result = [];

    switch (widget.category) {
      case TodoCategories.all:
        result = todos;
        break;
      case TodoCategories.today:
      case TodoCategories.upcoming:
        result =
            todos.where((todo) => todo.category == widget.category).toList();
        break;
    }

    if (widget.status != null) {
      switch (widget.status!) {
        case TodoStatuses.pending:
          result = result.where((todo) => !todo.isDone).toList();
          break;
        case TodoStatuses.completed:
          result = result.where((todo) => todo.isDone).toList();
          break;
      }
    }

    if (widget.searchText != null && widget.searchText!.isNotEmpty) {
      result = result
          .where((todo) => todo.title
              .toLowerCase()
              .contains(widget.searchText!.toLowerCase()))
          .toList();
    }

    return result;
  }

  void onToggleStatusDone(Todo todo) {
    final todoProvider = Provider.of<TodoProvider>(context, listen: false);
    final updatedTodo = todo.copyWith(
      status: todo.isDone ? TodoStatuses.pending : TodoStatuses.completed,
    );
    todoProvider.updateTodo(updatedTodo);
  }

  onItemDismissed(String id) {
    final todoProvider = Provider.of<TodoProvider>(context, listen: false);
    todoProvider.deleteTodo(id);

    // show snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Todo deleted successfully!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoProvider>(
      builder: (context, todoProvider, child) {
        final filteredTodos = _filterTodos(todoProvider.todos);
        return filteredTodos.isNotEmpty
            ? ListView.separated(
                itemCount: filteredTodos.length,
                itemBuilder: (context, index) {
                  final todo = filteredTodos[index];
                  return TodoListItem(
                    isDisable: widget.allowDelete,
                    todo: todo,
                    onToggleStatus: (todo) {
                      onToggleStatusDone(todo);
                    },
                    onDismissed: (id) {
                      widget.allowDelete && onItemDismissed(id);
                    },
                  );
                },
                separatorBuilder: (context, index) => const Gap(16),
              )
            : Center(
                child: Text(widget.emptyText),
              );
      },
    );
  }
}
