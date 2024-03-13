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
    return SearchAnchor(
        builder: (BuildContext context, SearchController controller) {
      return SearchBar(
          controller: controller,
          padding: const MaterialStatePropertyAll<EdgeInsets>(
              EdgeInsets.symmetric(horizontal: 16.0)),
          onTap: () {
            controller.openView();
          },
          onChanged: (_) {
            controller.openView();
            widget.searchValueCallback(controller.text);
          },
          leading: const Icon(Icons.search),
          hintText: widget.hintText);
    }, suggestionsBuilder: (BuildContext context, SearchController controller) {
      return List<ListTile>.generate(5, (int index) {
        final String item = 'item $index';
        return ListTile(
          title: Text(item),
          onTap: () {
            setState(() {
              controller.closeView(item);
            });
          },
        );
      });
    });
  }
}