import 'package:flutter/material.dart';
import 'package:todo_list/ui/widgets/widgets.dart';
import 'package:todo_list/constants/constants.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  TodoCategories selectedCategory = TodoCategories.all;

  void onSelectedCategory(TodoCategories newCategory) {
    setState(() {
      selectedCategory = newCategory;
    });
  }

  bool isSelected(TodoCategories category) {
    return selectedCategory == category;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          TodoDetailModal.showCreate(context);
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  CategoryButton(
                    "All",
                    isSelected(TodoCategories.all),
                    () => onSelectedCategory(TodoCategories.all),
                  ),
                  Spacer(),
                  CategoryButton(
                    "Today",
                    isSelected(TodoCategories.today),
                    () => onSelectedCategory(TodoCategories.today),
                  ),
                  Spacer(),
                  CategoryButton(
                    "Upcoming",
                    isSelected(TodoCategories.upcoming),
                    () => onSelectedCategory(TodoCategories.upcoming),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: TodoList(
                  category: selectedCategory,
                  status: TodoStatuses.pending,
                  emptyText: "No available tasks",
                  allowDelete: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
