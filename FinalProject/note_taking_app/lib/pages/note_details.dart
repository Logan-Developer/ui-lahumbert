import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../data_repository.dart';
import '../types.dart';
import '../widgets/my_quill_editor.dart';

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

  late QuillController _contentQuillController;

  @override
  void initState() {
    super.initState();
    fetchNote().then((value) => {
          setState(() {
            _contentQuillController = QuillController.basic()
              ..document = Document.fromJson(jsonDecode(_noteContent));
          })
        });
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
                context
                    .push('/class/${widget.className}/${widget.noteName}/edit',
                        extra: _noteContent)
                    .then((value) => {
                          if (value != null)
                            {
                              context.pop(NoteDetailsExtra(
                                  type: ExtraType.edit,
                                  className: widget.className,
                                  noteName: value as String,
                                  oldNoteName: widget.noteName))
                            }
                        });
              },
              icon: const Icon(Icons.edit),
              tooltip: 'Edit note'),
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
              child: MyQuillEditor(
                controller: _contentQuillController,
                isReadOnly: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
