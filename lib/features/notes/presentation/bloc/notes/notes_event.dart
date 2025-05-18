part of 'notes_bloc.dart';
sealed class NotesEvent {}
class LoadNotesEvent extends NotesEvent {}
class SearchNotesEvent extends NotesEvent {
  final String query;
  SearchNotesEvent(this.query);
}
class SortNotesEvent extends NotesEvent {
  final SortOrder order;
  SortNotesEvent(this.order);
}
class DeleteNoteEvent extends NotesEvent {
  final String id;

  DeleteNoteEvent(this.id);
}
class EditNoteEvent extends NotesEvent {
  final Note note;
  EditNoteEvent(this.note);
}
