import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../data_repository.dart';
import '../types.dart';

class NoteDetails extends StatefulWidget {
  const NoteDetails(
      {super.key,
      required this.title,
      required this.className,
      required this.noteName});

  final String title;
  final String className;
  final String noteName;

  @override
  State<NoteDetails> createState() => _NoteDetailsState();
}

class _NoteDetailsState extends State<NoteDetails> {
  String _noteContent = '';

  @override
  void initState() {
    super.initState();
    fetchNote();
  }

  Future<void> fetchNote() async {
    final repository = Provider.of<DataRepository>(context, listen: false);
    final note = await repository.fetchNote(widget.className, widget.noteName);
    setState(() {
      _noteContent = note['content'] as String;
    });
  }

  Future<void> deleteNote() async {
    final repository = Provider.of<DataRepository>(context, listen: false);
    await repository.deleteNote(widget.className, widget.noteName);
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
                        title: const Text('Delete note'),
                        content: const Text(
                            'Are you sure you want to delete this note?'),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancel')),
                          TextButton(
                              onPressed: () async {
                                await deleteNote().then((value) => {
                                      context.pop(),
                                      context.pop(NoteDetailsExtra(
                                          type: ExtraType.delete,
                                          className: widget.className,
                                          noteName: widget.noteName))
                                    });
                              },
                              child: const Text('Delete')),
                        ],
                      );
                    });
              },
              icon: const Icon(Icons.delete),
              tooltip: 'Delete note'),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Text(_noteContent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
