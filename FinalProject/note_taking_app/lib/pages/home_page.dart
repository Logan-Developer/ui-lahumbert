import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../data_repository.dart';
import '../widgets/my_search_widget.dart';

import '../types.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> classes = [];
  String searchValue = '';

  @override
  void initState() {
    super.initState();
    loadClasses();
  }

  Future<void> loadClasses() async {
    final repository = Provider.of<DataRepository>(context, listen: false);
    final classes = await repository.fetchClasses();
    setState(() {
      this.classes = classes;
    });
  }

  void addClass(String className) {
    setState(() {
      classes.add(className);
    });
  }

  void editClass(String oldClassName, String newClassName) {
    setState(() {
      print('oldClassName: $oldClassName, newClassName: $newClassName');
      final index = classes.indexOf(oldClassName);
      classes[index] = newClassName;
    });
  }

  void deleteClass(String className) {
    setState(() {
      classes.remove(className);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(widget.title)),
        body: Center(
            child: Column(children: [
          MySearchWidget(
              hintText: 'Search your classes',
              searchValueCallback: (value) => setState(() {
                    searchValue = value;
                  })),
          Expanded(
              child: Container(
                  padding: const EdgeInsets.all(100),
                  child: ListView.separated(
                      separatorBuilder: (BuildContext context, int index) =>
                          const SizedBox(height: 10),
                      itemCount: classes.length,
                      itemBuilder: (BuildContext context, int index) {
                        final className = classes[index];
                        if (searchValue.isNotEmpty &&
                            !className.contains(searchValue)) {
                          return const SizedBox.shrink();
                        }
                        return GestureDetector(
                            onTap: () {
                              context.push('/class/$className').then((value) {
                                if (value is NoteListPageExtra) {
                                  final extra = value;
                                  if (extra.type ==
                                      NoteListPageExtraType.delete) {
                                    deleteClass(extra.className);
                                  } else if (extra.type ==
                                      NoteListPageExtraType.edit) {
                                    editClass(
                                        extra.oldClassName, extra.className);
                                  }
                                }
                              });
                            },
                            child: Card(
                                child: Column(children: [
                              ListTile(
                                title: Text(className),
                                subtitle: const Text('Last changed DATE'),
                              ),
                            ])));
                      }))),
        ])),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            context.push('/create-class').then((className) {
              if (className != null) {
                addClass(className as String);
              }
            });
          },
          label: const Text('Add Class'),
          icon: const Icon(Icons.add),
        ));
  }
}
