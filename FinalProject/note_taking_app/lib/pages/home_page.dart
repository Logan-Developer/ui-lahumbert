import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
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
  List<dynamic> classes = [];
  String searchValue = '';

  @override
  void initState() {
    super.initState();
    loadClasses();
  }

  Future<void> loadClasses() async {
    final repository = Provider.of<DataRepository>(context, listen: false);
    final classes = await repository.fetchClasses();
    classes.sort((a, b) => b['lastUpdated'].compareTo(a['lastUpdated']));
    setState(() {
      this.classes = classes;
    });
  }

  void addClass(String className) {
    setState(() {
      classes.insert(
          0, {'name': className, 'lastUpdated': DateTime.now().toString()});
    });
  }

  void editClass(String oldClassName, String newClassName) {
    setState(() {
      final index =
          classes.indexWhere((element) => element['name'] == oldClassName);
      classes[index]['name'] = newClassName;
      classes[index]['lastUpdated'] = DateTime.now().toString();
    });
    classes.sort((a, b) => b['lastUpdated'].compareTo(a['lastUpdated']));
  }

  void deleteClass(String className) {
    setState(() {
      classes.removeWhere((element) => element['name'] == className);
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
              child: classes.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset('no_data.jpg', scale: 5),
                          const SizedBox(height: 20),
                          Text(
                            'No classes yet',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const Text('Tap the + button to add a class'),
                        ],
                      ),
                    )
                  : Container(
                      padding: const EdgeInsets.all(100),
                      child: ListView.separated(
                          separatorBuilder: (BuildContext context, int index) =>
                              const SizedBox(height: 10),
                          itemCount: classes.length,
                          itemBuilder: (BuildContext context, int index) {
                            final String className = classes[index]['name'];
                            final String lastUpdated =
                                classes[index]['lastUpdated'];
                            if (searchValue.isNotEmpty &&
                                !className
                                    .toLowerCase()
                                    .contains(searchValue.toLowerCase())) {
                              return const SizedBox.shrink();
                            }
                            return GestureDetector(
                                onTap: () {
                                  context
                                      .push('/class/$className')
                                      .then((value) {
                                    if (value is NoteListPageExtra) {
                                      final extra = value;
                                      if (extra.type == ExtraType.delete) {
                                        deleteClass(extra.className);
                                      } else if (extra.type == ExtraType.edit) {
                                        editClass(extra.oldClassName,
                                            extra.className);
                                      }
                                    }
                                  }).then((value) => loadClasses());
                                },
                                child: Card(
                                    child: Column(children: [
                                  ListTile(
                                      title: Text(className),
                                      subtitle: Text(
                                          'Last changed on ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(lastUpdated))}')),
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
