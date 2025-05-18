part of 'notes_bloc.dart';
sealed class NotesState {}
final class NotesInitial extends NotesState {}
class NotesLoading extends NotesState {}
class NotesSuccess extends NotesState {
  final List<Note> notes;
  NotesSuccess(this.notes);
}
class NotesError extends NotesState {}