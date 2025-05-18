import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:notes_task/features/notes/domain/entities/note.dart';
import 'package:notes_task/features/notes/presentation/screens/note_edit_screen.dart';
import 'package:notes_task/features/notes/presentation/screens/notes_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter route = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: "/",
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: '/',
      name: 'notes',
      builder: (context, state) => const NotesScreen(),
    ),
    GoRoute(
      path: '/edit',
      name: 'note_edit',
      builder: (context, state) {
        final note = state.extra as Note?;
        return NoteEditScreen(initialNote: note);
      },
    ),

  ],
);
