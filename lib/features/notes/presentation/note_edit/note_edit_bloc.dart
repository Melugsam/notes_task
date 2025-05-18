import 'package:bloc/bloc.dart';
import 'package:notes_task/features/notes/domain/entities/note.dart';
import 'package:notes_task/features/notes/domain/repository/note_repository.dart';

part 'note_edit_event.dart';

part 'note_edit_state.dart';

class NoteEditBloc extends Bloc<NoteEditEvent, NoteEditState> {
  final NoteRepository repository;
  final Note? initialNode;

  NoteEditBloc(this.repository, this.initialNode)
    : super(NoteEditInitial(initialNode ?? Note.empty())) {
    on<NoteEditedEvent>((event, emit) {
      emit(NoteEditInitial(event.note));
    });

    on<NoteEditSubmittedEvent>((event, emit) async {
      emit(NoteEditLoading(state.note));

      if (state.note.title.trim().isEmpty) {
        emit(
          NoteEditValidationError('Заголовок не может быть пустым', state.note),
        );
        return;
      }

      final note =
          state.note.id.isEmpty
              ? state.note.copyWith(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                createdAt: DateTime.now(),
              )
              : state.note;

      try {
        emit(NoteEditSuccess(note));
      } catch (e) {
        emit(NoteEditValidationError('Ошибка сохранения', note));
      }
    });
  }
}
