import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../data_repository.dart';
import '../widgets/my_search_widget.dart';

class NotesListPage extends StatefulWidget {
  const NotesListPage(
      {super.key, required this.title, required this.className});

  final String title;
  final String className;

  @override
  State<NotesListPage> createState() => _NotesListPageState();
}

class _NotesListPageState extends State<NotesListPage> {
  List<String> notes = [];
  String searchValue = '';

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  Future<void> loadNotes() async {
    final repository = Provider.of<DataRepository>(context, listen: false);
    final notes = await repository.fetchNotes(widget.className);
    setState(() {
      this.notes = notes;
    });
  }

  Future<void> deleteClass() async {
    final repository = Provider.of<DataRepository>(context, listen: false);
    await repository.deleteClass(widget.className);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () {
                // display a dialog to confirm the deletion
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Delete Class'),
                        content: const Text(
                            'Are you sure you want to delete this class? It will also delete all the notes in it.'),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancel')),
                          TextButton(
                              onPressed: () {
                                deleteClass().then((value) => context.go('/'));
                              },
                              child: const Text('Delete'))
                        ],
                      );
                    });
              },
              icon: const Icon(Icons.delete),
              tooltip: 'Delete class'),
        ],
      ),
      body: Center(
          child: Column(children: [
        MySearchWidget(
            hintText: 'Search your notes',
            searchValueCallback: (value) => setState(() {
                  searchValue = value;
                })),
        Expanded(
            child: Container(
                padding: const EdgeInsets.all(100),
                child: ListView.separated(
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(height: 10),
                    itemCount: notes.length,
                    itemBuilder: (BuildContext context, int index) {
                      final className = notes[index];
                      if (searchValue.isNotEmpty &&
                          !className.contains(searchValue)) {
                        return const SizedBox.shrink();
                      }
                      return Card(
                        child: Column(children: [
                          ListTile(
                            title: Text(notes[index]),
                            subtitle: const Text('Last changed DATE'),
                          )
                        ]),
                      );
                    }))),
      ])),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.go('/notes-list/${widget.className}/create-note');
        },
        label: const Text('Add Note'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
