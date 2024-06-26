import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../data_repository.dart';
import '../widgets/my_search_widget.dart';
import '../types.dart';

class NotesListPage extends StatefulWidget {
  const NotesListPage(
      {super.key, required this.title, required this.className});

  final String title;
  final String className;

  @override
  State<NotesListPage> createState() => _NotesListPageState();
}

class _NotesListPageState extends State<NotesListPage> {
  List<dynamic> notes = [];
  String searchValue = '';

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  Future<void> loadNotes() async {
    final repository = Provider.of<DataRepository>(context, listen: false);
    final notes = await repository.fetchNotes(widget.className);
    notes.sort((a, b) => b['lastUpdated'].compareTo(a['lastUpdated']));
    setState(() {
      this.notes = notes;
    });
  }

  Future<void> addNote(String noteName) async {
    setState(() {
      notes.insert(
          0, {'name': noteName, 'lastUpdated': DateTime.now().toString()});
    });
  }

  Future<void> deleteClass() async {
    final repository = Provider.of<DataRepository>(context, listen: false);
    await repository.deleteClass(widget.className);
  }

  void editNote(String oldNoteName, String newNoteName) {
    setState(() {
      final index =
          notes.indexWhere((element) => element['name'] == oldNoteName);
      notes[index]['name'] = newNoteName;
      notes[index]['lastUpdated'] = DateTime.now().toString();
    });
    notes.sort((a, b) => b['lastUpdated'].compareTo(a['lastUpdated']));
  }

  void deleteNote(String noteName) {
    setState(() {
      notes.removeWhere((element) => element['name'] == noteName);
    });
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
                context
                    .push('/class/${widget.className}/edit')
                    .then((value) => {
                          if (value != null)
                            {
                              context.pop(NoteListPageExtra(
                                  type: ExtraType.edit,
                                  className: value as String,
                                  oldClassName: widget.className))
                            }
                        });
              },
              icon: const Icon(Icons.edit),
              tooltip: 'Edit class'),
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
                                deleteClass().then((value) => {
                                      context.pop(),
                                      context.pop(NoteListPageExtra(
                                          type: ExtraType.delete,
                                          className: widget.className))
                                    });
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
            child: notes.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Image(
                            image: AssetImage('no_data.jpg'), height: 400),
                        const SizedBox(height: 20),
                        Text(
                          'No notes yet',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const Text('Tap the + button to add a note'),
                      ],
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.all(100),
                    child: ListView.separated(
                        separatorBuilder: (BuildContext context, int index) =>
                            const SizedBox(height: 10),
                        itemCount: notes.length,
                        itemBuilder: (BuildContext context, int index) {
                          final String noteName = notes[index]['name'];
                          final String lastUpdated =
                              notes[index]['lastUpdated'];
                          if (searchValue.isNotEmpty &&
                              !noteName
                                  .toLowerCase()
                                  .contains(searchValue.toLowerCase())) {
                            return const SizedBox.shrink();
                          }
                          return GestureDetector(
                              onTap: () {
                                context
                                    .push(
                                        '/class/${widget.className}/$noteName')
                                    .then((value) {
                                  if (value is NoteDetailsExtra) {
                                    final extra = value;
                                    if (extra.type == ExtraType.delete) {
                                      deleteNote(extra.noteName);
                                    } else if (extra.type == ExtraType.edit) {
                                      editNote(
                                          extra.oldNoteName, extra.noteName);
                                    }
                                  }
                                });
                              },
                              child: Card(
                                child: Column(children: [
                                  ListTile(
                                      title: Text(notes[index]['name']),
                                      subtitle: Text(
                                          'Last changed on ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(lastUpdated))}'))
                                ]),
                              ));
                        }))),
      ])),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context
              .push('/class/${widget.className}/create-note')
              .then((value) => {
                    if (value != null) {addNote(value as String)}
                  });
        },
        label: const Text('Add Note'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
