import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/note_model.dart';
import 'note_source.dart';

class NoteSourceImpl implements NoteSource {
  static const String _storageKey = 'notes';

  final SharedPreferences prefs;

  NoteSourceImpl(this.prefs);

  @override
  Future<void> add(NoteModel model) async {
    final notes = await getAll();
    notes.add(model);
    await _saveList(notes);
  }

  @override
  Future<void> update(NoteModel model) async {
    final notes = await getAll();
    final index = notes.indexWhere((e) => e.id == model.id);
    if (index != -1) {
      notes[index] = model;
      await _saveList(notes);
    }
  }

  @override
  Future<void> delete(String id) async {
    final notes = await getAll();
    notes.removeWhere((e) => e.id == id);
    await _saveList(notes);
  }

  @override
  Future<List<NoteModel>> getAll() async {
    final raw = prefs.getString(_storageKey);
    if (raw == null) return [];
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded.map((e) => NoteModel.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  Future<void> _saveList(List<NoteModel> notes) async {
    final encoded = jsonEncode(notes.map((e) => e.toJson()).toList());
    await prefs.setString(_storageKey, encoded);
  }
}
