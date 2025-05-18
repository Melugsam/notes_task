part of 'note_edit_bloc.dart';

sealed class NoteEditState {
  final Note note;

  const NoteEditState(this.note);
}

final class NoteEditInitial extends NoteEditState {
  const NoteEditInitial(super.note);
}

final class NoteEditLoading extends NoteEditState {
  const NoteEditLoading(super.note);
}

final class NoteEditSuccess extends NoteEditState {
  const NoteEditSuccess(super.note);
}

final class NoteEditValidationError extends NoteEditState {
  final String message;

  const NoteEditValidationError(this.message, Note note) : super(note);
}
