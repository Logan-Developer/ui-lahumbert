import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'pages/create_class_page.dart';
import 'pages/home_page.dart';
import 'data_repository.dart';

void main() {
  runApp(Provider(create: (context) => DataRepository(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) =>
            const HomePage(title: 'My Note-Taking App'),
      ),
      GoRoute(
          path: '/create-class',
          builder: (context, state) {
            return const CreateClassPage(title: 'Create a new class');
          }),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'My Note-Taking App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}
