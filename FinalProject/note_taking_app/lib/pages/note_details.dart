import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(widget.noteName),
            const SizedBox(height: 20),
            const Text('Note content'),
          ],
        ),
      ),
    );
  }
}
