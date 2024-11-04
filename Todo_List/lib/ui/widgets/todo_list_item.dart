import 'package:flutter/material.dart';
import 'package:todo_list/ui/widgets/widgets.dart';
import 'package:touchable_opacity/touchable_opacity.dart';
import 'package:todo_list/utils/utils.dart';
import 'package:todo_list/models/models.dart';

class TodoListItem extends StatefulWidget {
  final Todo todo;
  final Function(Todo) onToggleStatus;

  const TodoListItem({
    super.key,
    required this.todo,
    required this.onToggleStatus,
  });

  @override
  TodoListItemState createState() => TodoListItemState();
}

class TodoListItemState extends State<TodoListItem> {

  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      activeOpacity: 0.5,
      onTap: () => TodoDetailModal.showDetail(context, widget.todo),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            TouchableOpacity(
              onTap: () => widget.onToggleStatus(widget.todo),
              child: widget.todo.isDone
                  ? Icon(
                      Icons.check_circle,
                      color: Theme.of(context).primaryColor,
                      size: 24,
                    )
                  : Icon(
                      Icons.radio_button_unchecked,
                      color: Colors.grey,
                      size: 24,
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.todo.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    widget.todo.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  widget.todo.dueTime != null
                      ? dateFormat.format(widget.todo.dueTime!)
                      : "",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: widget.todo.isDue
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context).colorScheme.primary,
                  ),
                ),
                Text(
                  widget.todo.dueTime != null
                      ? timeFormat.format(widget.todo.dueTime!)
                      : "",
                  style: TextStyle(
                    fontSize: 12,
                    color: widget.todo.isDue
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
