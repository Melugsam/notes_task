import 'package:notes_task/features/notes/data/models/note_model.dart';

abstract class NoteSource {
  Future<List<NoteModel>> getAll();
  Future<void> add(NoteModel note);
  Future<void> update(NoteModel note);
  Future<void> delete(String id);
}
