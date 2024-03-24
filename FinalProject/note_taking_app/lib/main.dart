import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'pages/create_class_page.dart';
import 'pages/create_note_page.dart';
import 'pages/home_page.dart';
import 'data_repository.dart';
import 'pages/note_details.dart';
import 'pages/notes_list_page.dart';

void main() {
  runApp(Provider(create: (context) => DataRepository(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _router = GoRouter(routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(title: 'My Note-Taking App'),
    ),
    GoRoute(
        path: '/class/:className',
        builder: (context, state) {
          final className = state.pathParameters['className'];
          if (className == null) {
            return const SizedBox.shrink();
          }
          return NotesListPage(title: className, className: className);
        },
        routes: [
          GoRoute(
              path: 'edit',
              builder: (context, state) {
                final className = state.pathParameters['className'];
                if (className == null) {
                  return const SizedBox.shrink();
                }
                return CreateClassPage(
                    title: 'Edit class $className',
                    currentClassName: className);
              }),
          GoRoute(
              path: 'create-note',
              builder: (context, state) {
                final className = state.pathParameters['className'];
                if (className == null) {
                  return const SizedBox.shrink();
                }
                return CreateNotePage(
                    title: 'Create a note', className: className);
              }),
          GoRoute(
              path: ':noteName',
              builder: (context, state) {
                final className = state.pathParameters['className'];
                final noteName = state.pathParameters['noteName'];
                if (className == null || noteName == null) {
                  return const SizedBox.shrink();
                }
                return NoteDetails(
                    title: noteName, className: className, noteName: noteName);
              },
              routes: [
                GoRoute(
                    path: 'edit',
                    builder: (context, state) {
                      final className = state.pathParameters['className'];
                      final noteName = state.pathParameters['noteName'];
                      final content = state.extra as String?;
                      if (className == null || noteName == null) {
                        return const SizedBox.shrink();
                      }
                      return CreateNotePage(
                          title: 'Edit note $noteName',
                          className: className,
                          currentNoteName: noteName,
                          currentNoteContent: content);
                    })
              ])
        ]),
    GoRoute(
      path: '/create-class',
      builder: (context, state) =>
          const CreateClassPage(title: 'Create a class'),
    )
  ]);

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
