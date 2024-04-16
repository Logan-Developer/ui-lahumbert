import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../data_repository.dart';

class CreateClassPage extends StatefulWidget {
  const CreateClassPage(
      {super.key, required this.title, this.currentClassName});

  final String title;
  final String? currentClassName;

  @override
  State<CreateClassPage> createState() => _CreateClassPageState();
}

class _CreateClassPageState extends State<CreateClassPage> {
  late TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController()..text = widget.currentClassName ?? '';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> createClass() async {
    final repository = Provider.of<DataRepository>(context, listen: false);
    await repository.addClass(_controller.text);
  }

  Future<void> updateClass() async {
    final repository = Provider.of<DataRepository>(context, listen: false);
    await repository.updateClass(widget.currentClassName!, _controller.text);
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
                        return 'Please enter a class name';
                      }
                      if (value.length > 20) {
                        return 'Class name must be less than 20 characters';
                      }
                      // special characters are not allowed
                      if (RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]')
                          .hasMatch(value)) {
                        return 'Special characters are not allowed';
                      }
                      return null;
                    },
                    controller: _controller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Class name',
                    ),
                  ),
                  const SizedBox(height: 20),
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
                          if (widget.currentClassName != null) {
                            updateClass();
                          } else {
                            createClass();
                          }
                          context.pop(_controller.text);
                        },
                        child: Text(widget.currentClassName != null
                            ? 'Edit'
                            : 'Create'),
                      )
                    ],
                  ),
                ]))));
  }
}
