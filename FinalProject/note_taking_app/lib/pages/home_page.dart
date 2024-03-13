import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data_repository.dart';
import '../widgets/my_search_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> classes = [];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
          child: Column(children: [
        MySearchWidget(
            hintText: 'Search your classes',
            searchValueCallback: (value) => {}),
        Expanded(
            child: Container(
                padding: const EdgeInsets.all(100),
                child: ListView.separated(
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(height: 10),
                    itemCount: classes.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: Column(children: [
                          ListTile(
                            title: Text(classes[index]),
                            subtitle: const Text('Last changed DATE'),
                          )
                        ]),
                      );
                    }))),
      ])),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Add fab action
        },
        label: const Text('Add Class'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
