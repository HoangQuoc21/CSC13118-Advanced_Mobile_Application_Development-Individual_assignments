import 'package:flutter/material.dart';

class MySearchBar extends StatefulWidget {
  const MySearchBar({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  MySearchBarState createState() => MySearchBarState();
}

class MySearchBarState extends State<MySearchBar> {
  bool _showClearIcon = false;
  bool _isFocused = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    _focusNode.removeListener(_onFocusChanged);
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _showClearIcon = widget.controller.text.isNotEmpty;
    });
  }

  void _onFocusChanged() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: _isFocused
            ? Theme.of(context).colorScheme.surfaceContainerLowest
            : Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: _isFocused
              ? Theme.of(context).primaryColor
              : Theme.of(context).colorScheme.surface,
        ),
      ),
      child: TextField(
        controller: widget.controller,
        focusNode: _focusNode,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          hintText: 'Search',
          alignLabelWithHint: true,
          border: InputBorder.none,
          icon: Icon(
            Icons.search,
            color: Theme.of(context).primaryColor,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          suffixIcon: _showClearIcon
              ? IconButton(
                  icon: const Icon(Icons.cancel),
                  onPressed: () {
                    widget.controller.clear();
                  },
                  color: Theme.of(context).colorScheme.primary,
                )
              : null,
        ),
      ),
    );
  }
}
