import 'package:freezed_annotation/freezed_annotation.dart';

part 'note.freezed.dart';

enum SortOrder {
  newestFirst,
  oldestFirst,
}

@freezed
abstract class Note with _$Note {
  const factory Note({
    required String id,
    required String title,
    required String content,
    required DateTime createdAt,
    @Default(false) bool isPinned,
  }) = _Note;

  factory Note.empty() => Note(
    id: '',
    title: '',
    content: '',
    createdAt: DateTime.now(),
    isPinned: false,
  );
}
