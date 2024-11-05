import 'package:flutter/material.dart';
import 'package:taskist/ui/widgets/widgets.dart';
import 'package:taskist/constants/constants.dart';
import 'package:gap/gap.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchTextController.addListener(_onSearchTextChanged);
  }

  @override
  void dispose() {
    _searchTextController.removeListener(_onSearchTextChanged);
    _searchTextController.dispose();
    super.dispose();
  }

  void _onSearchTextChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            MySearchBar(
              controller: _searchTextController,
              hintText: 'Enter the task title',
            ),
            const Gap(16),
            Expanded(
              child: TodoList(
                category: TodoCategories.all,
                searchText: _searchTextController.text,
                emptyText: 'No available tasks',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
