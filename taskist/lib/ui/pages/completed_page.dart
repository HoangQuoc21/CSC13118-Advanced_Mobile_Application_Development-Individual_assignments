import 'package:flutter/material.dart';
import 'package:taskist/ui/widgets/widgets.dart';
import 'package:taskist/constants/constants.dart';

class CompletedPage extends StatelessWidget {
  const CompletedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: TodoList(
                category: TodoCategories.all,
                status: TodoStatuses.completed,
                emptyText: 'No completed tasks',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
