import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_task/core/injector/di.dart';
import 'package:notes_task/features/notes/domain/entities/note.dart';
import 'package:notes_task/features/notes/presentation/bloc/notes/notes_bloc.dart';
import 'package:notes_task/features/notes/presentation/note_edit/note_edit_bloc.dart';

class NoteEditScreen extends StatefulWidget {
  final Note? initialNote;

  const NoteEditScreen({super.key, this.initialNote});

  @override
  State<NoteEditScreen> createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends State<NoteEditScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _contentController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NoteEditBloc(getIt(), widget.initialNote),
      child: BlocConsumer<NoteEditBloc, NoteEditState>(
        listenWhen:
            (prev, curr) =>
                curr is NoteEditSuccess || curr is NoteEditValidationError,
        listener: (context, state) {
          if (state is NoteEditSuccess) {
            context.read<NotesBloc>().add(EditNoteEvent(state.note));
            Navigator.of(context).pop();
          } else if (state is NoteEditValidationError) {
            Flushbar(
              message: state.message,
              duration: const Duration(seconds: 2),
              margin: const EdgeInsets.all(16),
              borderRadius: BorderRadius.circular(16),
              backgroundColor: Colors.redAccent,
              flushbarPosition: FlushbarPosition.TOP,
              animationDuration: const Duration(milliseconds: 300),
            ).show(context);
          }
        },
        builder: (context, state) {
          _titleController.value = TextEditingValue(
            text: state.note.title,
            selection: TextSelection.collapsed(offset: state.note.title.length),
          );
          _contentController.value = TextEditingValue(
            text: state.note.content,
            selection: TextSelection.collapsed(
              offset: state.note.content.length,
            ),
          );
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: Text(
                state.note.id.isNotEmpty
                    ? 'Редактировать заметку'
                    : 'Новая заметка',
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: () {
                    context.read<NoteEditBloc>().add(NoteEditSubmittedEvent());
                  },
                ),
              ],
            ),
            body: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  TextField(
                    controller: _titleController,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    decoration: const InputDecoration.collapsed(
                      hintText: 'Заголовок',
                    ),
                    onChanged: (value) {
                      final updated = state.note.copyWith(title: value);
                      context.read<NoteEditBloc>().add(
                        NoteEditedEvent(updated),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: TextField(
                      controller: _contentController,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(fontSize: 16),
                      decoration: const InputDecoration.collapsed(
                        hintText: 'Текст заметки...',
                      ),
                      maxLines: null,
                      expands: true,
                      onChanged: (value) {
                        final updated = state.note.copyWith(content: value);
                        context.read<NoteEditBloc>().add(
                          NoteEditedEvent(updated),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
