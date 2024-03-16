import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../data_repository.dart';

class CreateNotePage extends StatefulWidget {
  const CreateNotePage(
      {super.key, required this.title, required this.className});

  final String title;
  final String className;

  @override
  State<CreateNotePage> createState() => _CreateNotePageState();
}

class _CreateNotePageState extends State<CreateNotePage> {
  String noteName = '', content = '';

  late TextEditingController _noteNameController, _contentController;

  @override
  void initState() {
    super.initState();
    _noteNameController = TextEditingController();
    _contentController = TextEditingController();
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
          TextField(
            controller: _contentController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Content',
            ),
            maxLines: 10,
            onChanged: (value) => setState(() {
              content = value;
            }),
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
                  createNote();
                  context.pop(_noteNameController.text);
                },
                child: const Text('Create'),
              )
            ],
          ),
        ])));
  }
}
