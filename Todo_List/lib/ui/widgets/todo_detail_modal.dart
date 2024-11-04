import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/utils/utils.dart';
import 'package:todo_list/models/models.dart';
import 'package:todo_list/constants/constants.dart';
import 'package:todo_list/providers/todo_provider.dart';

enum TodoDetailMode { add, update }

class TodoDetailModal extends StatefulWidget {
  final TodoDetailMode mode;
  final Todo? todo;

  const TodoDetailModal({
    super.key,
    required this.mode,
    this.todo,
  });

  static void showCreate(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => TodoDetailModal(mode: TodoDetailMode.add),
    );
  }

  static void showDetail(BuildContext context, Todo todo) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) =>
          TodoDetailModal(mode: TodoDetailMode.update, todo: todo),
    );
  }

  @override
  TodoDetailModalState createState() => TodoDetailModalState();
}

class TodoDetailModalState extends State<TodoDetailModal> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDueDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (!mounted) return;

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (!mounted) return;

      if (pickedTime != null) {
        setState(() {
          _selectedDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _saveTodo() {
    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _selectedDate == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text("Please fill all the fields"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK"),
            ),
          ],
        ),
      );
      return;
    }

    final newTodo = Todo(
      title: _titleController.text,
      description: _descriptionController.text,
      status: TodoStatuses.pending,
      dueTime: _selectedDate,
    );

    Provider.of<TodoProvider>(context, listen: false).addTodo(newTodo);

    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Todo created successfully!")),
    );
  }

  void _updateTodo() {
    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _selectedDate == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text("Please fill all the fields"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK"),
            ),
          ],
        ),
      );
      return;
    }

    final updatedTodo = Todo.withId(
      id: widget.todo!.id,
      title: _titleController.text,
      description: _descriptionController.text,
      status: widget.todo!.status,
      dueTime: _selectedDate,
    );

    Provider.of<TodoProvider>(context, listen: false).updateTodo(updatedTodo);

    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Todo updated successfully!")),
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.mode == TodoDetailMode.update && widget.todo != null) {
      _titleController.text = widget.todo!.title;
      _descriptionController.text = widget.todo!.description;
      _selectedDate = widget.todo!.dueTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            enabled: widget.mode == TodoDetailMode.add ||
                widget.todo?.isDone == false,
            controller: _titleController,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            decoration: InputDecoration(
              labelText: 'Title',
              labelStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            enabled: widget.mode == TodoDetailMode.add ||
                widget.todo?.isDone == false,
            controller: _descriptionController,
            decoration: InputDecoration(labelText: 'Description'),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              TextButton(
                onPressed: widget.mode == TodoDetailMode.add ||
                        widget.todo?.isDone == false
                    ? _pickDueDate
                    : null,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.calendar_today),
                    const SizedBox(width: 8),
                    Text(
                      _selectedDate != null
                          ? "${dateFormat.format(_selectedDate!)} - ${timeFormat.format(_selectedDate!)}"
                          : "Select due time",
                    ),
                  ],
                ),
              ),
              Spacer(),
              if (widget.mode == TodoDetailMode.add ||
                  widget.todo?.isDone == false)
                ElevatedButton(
                  onPressed: widget.mode == TodoDetailMode.add
                      ? _saveTodo
                      : _updateTodo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).buttonTheme.colorScheme?.primary,
                  ),
                  child: Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
