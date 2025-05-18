import 'package:flutter_test/flutter_test.dart';
import 'package:notes_task/features/notes/data/models/note_model.dart';

void main() {
  test('Модель должна преобразовываться из json корректно', () {
    final original = NoteModel(
      id: '123',
      title: 'Test Title',
      content: 'Test content',
      createdAt: DateTime(2025, 1, 1),
      isPinned: true,
    );

    final json = original.toJson();
    final restored = NoteModel.fromJson(json);

    expect(restored.id, original.id);
    expect(restored.title, original.title);
    expect(restored.content, original.content);
    expect(restored.createdAt, original.createdAt);
    expect(restored.isPinned, original.isPinned);
  });
}
