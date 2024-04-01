import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:go_router/go_router.dart';
import 'package:classsnap/widgets/my_quill_editor.dart';
import 'package:classsnap/widgets/my_quill_toolbar.dart';
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
  String get noteName => _noteNameController.text;
  String get content =>
      jsonEncode(_contentQuillController.document.toDelta().toJson());

  late TextEditingController _noteNameController;

  late QuillController _contentQuillController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _noteNameController = TextEditingController()
      ..text = widget.currentNoteName ?? '';

    _contentQuillController = QuillController.basic()
      ..document = widget.currentNoteContent != null
          ? Document.fromJson(jsonDecode(widget.currentNoteContent!))
          : Document();
  }

  @override
  void dispose() {
    _noteNameController.dispose();
    _contentQuillController.dispose();
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
            child: Form(
                key: _formKey,
                child: Column(children: [
                  const SizedBox(height: 20),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a note name';
                      }
                      if (value.length > 20) {
                        return 'Note name must be less than 20 characters';
                      }
                      return null;
                    },
                    controller: _noteNameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Note name',
                    ),
                  ),
                  const SizedBox(height: 20),
                  MyQuillToolbar(controller: _contentQuillController),
                  Expanded(
                    child: MyQuillEditor(
                      controller: _contentQuillController,
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
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }
                          if (widget.currentNoteName != null) {
                            updateNote();
                          } else {
                            createNote();
                          }
                          context.pop(_noteNameController.text);
                        },
                        child: Text(
                            widget.currentNoteName != null ? 'Edit' : 'Create'),
                      )
                    ],
                  ),
                ]))));
  }
}
