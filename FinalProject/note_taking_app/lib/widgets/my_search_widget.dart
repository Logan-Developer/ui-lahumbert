import 'package:flutter/material.dart';

typedef SearchValueCallback = void Function(String value);

class MySearchWidget extends StatefulWidget {
  const MySearchWidget(
      {super.key, required this.searchValueCallback, this.hintText});

  final String? hintText;
  final SearchValueCallback searchValueCallback;

  @override
  State<MySearchWidget> createState() => _MySearchWidgetState();
}

class _MySearchWidgetState extends State<MySearchWidget> {
  @override
  Widget build(BuildContext context) {
    return SearchBar(
      hintText: widget.hintText,
      onChanged: widget.searchValueCallback,
      leading: const Icon(Icons.search),
    );
  }
}
