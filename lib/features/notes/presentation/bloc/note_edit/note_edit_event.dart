part of 'note_edit_bloc.dart';

sealed class NoteEditEvent {}

class NoteEditedEvent extends NoteEditEvent {
  final Note note;

  NoteEditedEvent(this.note);
}
class NoteEditSubmittedEvent extends NoteEditEvent {}