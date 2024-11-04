import 'package:flutter/material.dart';
import 'package:todo_list/ui/widgets/widgets.dart';
import 'package:todo_list/constants/constants.dart';

class CompletedPage extends StatelessWidget {
  const CompletedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Expanded(
          child: TodoList(
            category: TodoCategories.all,
            status: TodoStatuses.completed,
            emptyText: 'No completed tasks',
          ),
        ),
      ),
    );
  }
}
