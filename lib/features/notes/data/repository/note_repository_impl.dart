import 'package:notes_task/features/notes/data/models/note_model.dart';
import 'package:notes_task/features/notes/data/sources/note_source.dart';
import 'package:notes_task/features/notes/domain/entities/note.dart';
import 'package:notes_task/features/notes/domain/repository/note_repository.dart';

class NoteRepositoryImpl implements NoteRepository {
  final NoteSource localSource;

  NoteRepositoryImpl(this.localSource);

  @override
  Future<List<Note>> getAllNotes() async {
    try {
      final models = await localSource.getAll();
      return models
          .map((m) => Note(
        id: m.id,
        title: m.title,
        content: m.content,
        createdAt: m.createdAt,
        isPinned: m.isPinned,
      ))
          .toList();
    } catch (e) {
      rethrow;
    }
  }


  @override
  Future<void> addNote(Note note) async {
    try {
      final model = NoteModel(
        id: note.id,
        title: note.title,
        content: note.content,
        createdAt: note.createdAt,
        isPinned: note.isPinned,
      );
      await localSource.add(model);
    } catch (e) {
      rethrow;
    }
  }


  @override
  Future<void> updateNote(Note note) async {
    try {
      final model = NoteModel(
        id: note.id,
        title: note.title,
        content: note.content,
        createdAt: note.createdAt,
        isPinned: note.isPinned,
      );
      await localSource.update(model);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteNote(String id) async {
    try {
      await localSource.delete(id);
    } catch (e) {
      rethrow;
    }
  }

}
