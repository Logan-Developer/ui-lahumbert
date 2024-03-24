import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:go_router/go_router.dart';
import 'package:note_taking_app/widgets/my_quill_toolbar.dart';
import 'package:provider/provider.dart';

import '../data_repository.dart';

class CreateNotePage extends StatefulWidget {
  const CreateNotePage(
      {super.key,
      required this.title,
      required this.className,
      this.currentNoteName,
      this.currentNoteContent});

  final String title;
  final String className;
  final String? currentNoteName;
  final String? currentNoteContent;

  @override
  State<CreateNotePage> createState() => _CreateNotePageState();
}

class _CreateNotePageState extends State<CreateNotePage> {
  String noteName = '', content = '';

  late TextEditingController _noteNameController, _contentController;

  late QuillController _contentQuillController;

  @override
  void initState() {
    super.initState();
    _noteNameController = TextEditingController()
      ..text = widget.currentNoteName ?? '';
    _contentController = TextEditingController()
      ..text = widget.currentNoteContent ?? '';

    _contentQuillController = QuillController.basic();
  }

  @override
  void dispose() {
    _noteNameController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> createNote() async {
    final repository = Provider.of<DataRepository>(context, listen: false);
    await repository.addNote(widget.className, noteName, content);
  }

  Future<void> updateNote() async {
    final repository = Provider.of<DataRepository>(context, listen: false);
    await repository.updateNote(
        widget.className, widget.currentNoteName!, noteName, content);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Center(
            child: Column(children: [
          const SizedBox(height: 20),
          TextField(
            controller: _noteNameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Note name',
            ),
            onChanged: (value) => setState(() {
              noteName = value;
            }),
          ),
          const SizedBox(height: 20),
          MyQuillToolbar(controller: _contentQuillController),
          Expanded(
            child: QuillEditor.basic(
              configurations: QuillEditorConfigurations(
                controller: _contentQuillController,
                readOnly: false,
                sharedConfigurations: const QuillSharedConfigurations(
                  locale: Locale('en'),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () {
                  if (widget.currentNoteName != null) {
                    updateNote();
                  } else {
                    createNote();
                  }
                  context.pop(_noteNameController.text);
                },
                child: Text(widget.currentNoteName != null ? 'Edit' : 'Create'),
              )
            ],
          ),
        ])));
  }
}
