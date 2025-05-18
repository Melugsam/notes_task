import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:notes_task/features/notes/domain/entities/note.dart';
import 'package:notes_task/features/notes/presentation/bloc/notes/notes_bloc.dart';

class NoteCard extends StatelessWidget {
  final Note note;

  const NoteCard({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(note.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) {
        context.read<NotesBloc>().add(DeleteNoteEvent(note.id));
      },
      child: SizedBox(
        width: double.infinity,
        child: GestureDetector(
          onTap: () async {
            await context.pushNamed('note_edit', extra: note);
          },
          onLongPressStart: (details) async {
            final selected = await showMenu<String>(
              context: context,
              position: RelativeRect.fromLTRB(
                details.globalPosition.dx,
                details.globalPosition.dy,
                details.globalPosition.dx,
                details.globalPosition.dy,
              ),
              items: const [
                PopupMenuItem(
                  value: 'edit',
                  height: 46,
                  child: Text('Редактировать'),
                ),
                PopupMenuItem(
                  value: 'delete',
                  height: 46,
                  child: Text('Удалить'),
                ),
              ],
            );

            if (!context.mounted || selected == null) return;

            switch (selected) {
              case 'edit':
                await context.pushNamed('note_edit', extra: note);
                break;
              case 'delete':
                context.read<NotesBloc>().add(DeleteNoteEvent(note.id));
                break;
            }
          },
          child: Card(
            elevation: 2,
            color: Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note.title,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    note.content,
                    maxLines: 10,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    note.createdAt.toString().split(' ').first,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
