import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notes_task/features/notes/domain/entities/note.dart';
import 'package:notes_task/features/notes/presentation/widgets/note_card.dart';

void main() {
  testWidgets('Проверка отображение title и content', (tester) async {
    final note = Note(
      id: '1',
      title: 'Test Title',
      content: 'Test Content',
      createdAt: DateTime(2025, 1, 1),
      isPinned: false,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: NoteCard(note: note),
        ),
      ),
    );

    expect(find.text('Test Title'), findsOneWidget);
    expect(find.text('Test Content'), findsOneWidget);
    expect(find.text('2025-01-01'), findsOneWidget);
  });
}
