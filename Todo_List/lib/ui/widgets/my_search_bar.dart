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
        color: _isFocused ? Colors.transparent : Colors.grey[200],
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: _isFocused
              ? Theme.of(context).primaryColor
              : (Colors.grey[300] ?? Colors.grey),
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
          icon: Icon(Icons.search),
          contentPadding:
              EdgeInsets.symmetric(vertical: 12), // Adjust this value as needed
          suffixIcon: _showClearIcon
              ? IconButton(
                  icon: Icon(Icons.cancel),
                  onPressed: () {
                    widget.controller.clear();
                  },
                )
              : null,
        ),
      ),
    );
  }
}
