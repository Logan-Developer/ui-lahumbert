import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../data_repository.dart';

class CreateClassPage extends StatefulWidget {
  const CreateClassPage({super.key, required this.title});

  final String title;

  @override
  State<CreateClassPage> createState() => _CreateClassPageState();
}

class _CreateClassPageState extends State<CreateClassPage> {
  String className = '';

  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> createClass() async {
    final repository = Provider.of<DataRepository>(context, listen: false);
    await repository.addClass(className);
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
          const Text('Create a new class'),
          const SizedBox(height: 20),
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Class name',
            ),
            onChanged: (value) => setState(() {
              className = value;
            }),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedButton(
                  onPressed: () {
                    context.go('/');
                  },
                  child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () {
                  createClass();
                  context.go('/'); // fix data not updating on home page
                },
                child: const Text('Create'),
              )
            ],
          ),
        ])));
  }
}
