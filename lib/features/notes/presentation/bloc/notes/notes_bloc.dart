import 'package:bloc/bloc.dart';
import 'package:notes_task/features/notes/domain/entities/note.dart';
import 'package:notes_task/features/notes/domain/repository/note_repository.dart';

part 'notes_event.dart';
part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final NoteRepository repository;

  NotesBloc(this.repository) : super(NotesInitial()) {
    on<LoadNotesEvent>((event, emit) async {
      emit(NotesLoading());
      try {
        final notes = await repository.getAllNotes();
        emit(NotesSuccess(notes));
      } catch (_) {
        emit(NotesError());
      }
    });

    on<SearchNotesEvent>((event, emit) async {
      try {
        final allNotes = await repository.getAllNotes();
        final filtered = allNotes
            .where((note) => note.title.toLowerCase().contains(event.query.toLowerCase()))
            .toList();
        emit(NotesSuccess(filtered));
      } catch (_) {
        emit(NotesError());
      }
    });

    on<SortNotesEvent>((event, emit) async {
      try {
        final allNotes = await repository.getAllNotes();
        final sorted = [...allNotes];
        sorted.sort((a, b) {
          if (event.order == SortOrder.newestFirst) {
            return b.createdAt.compareTo(a.createdAt);
          } else {
            return a.createdAt.compareTo(b.createdAt);
          }
        });
        emit(NotesSuccess(sorted));
      } catch (_) {
        emit(NotesError());
      }
    });

    on<EditNoteEvent>((event, emit) async {
      emit(NotesLoading());
      try {
        final note = event.note;
        if (note.id.isEmpty) return;
        final currentNotes = await repository.getAllNotes();
        final exist = currentNotes.any((n) => n.id == note.id);

        if (exist) {
          await repository.updateNote(note);
        } else {
          await repository.addNote(note);
        }

        final updated = await repository.getAllNotes();
        emit(NotesSuccess(updated));
      } catch (_) {
        emit(NotesError());
      }
    });

    on<DeleteNoteEvent>((e, emit) async {
      try {
        await repository.deleteNote(e.id);
        final all = await repository.getAllNotes();
        emit(NotesSuccess(all));
      } catch (_) {
        emit(NotesError());
      }
    });
  }
}
