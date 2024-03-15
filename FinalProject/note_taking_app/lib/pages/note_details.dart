import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data_repository.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
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
