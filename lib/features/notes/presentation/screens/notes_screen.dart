import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:notes_task/features/app/presentation/bloc/theme_cubit.dart';
import 'package:notes_task/features/notes/domain/entities/note.dart';
import 'package:notes_task/features/notes/presentation/bloc/notes/notes_bloc.dart';
import 'package:notes_task/features/notes/presentation/widgets/note_card.dart';
import 'package:notes_task/features/notes/presentation/widgets/note_search_field.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NotesBloc>().add(LoadNotesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Заметки'),
        actions: [
          PopupMenuButton<SortOrder>(
            icon: const Icon(Icons.sort),
            onSelected: (order) {
              context.read<NotesBloc>().add(SortNotesEvent(order));
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: SortOrder.newestFirst,
                child: Text('Сначала новые'),
              ),
              PopupMenuItem(
                value: SortOrder.oldestFirst,
                child: Text('Сначала старые'),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => showSettingsDialog(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await context.pushNamed('note_edit');
          if (!context.mounted) return;
          context.read<NotesBloc>().add(LoadNotesEvent());
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          NoteSearchField(
            onChanged: (query) {
              context.read<NotesBloc>().add(SearchNotesEvent(query));
            },
          ),
          Expanded(
            child: BlocBuilder<NotesBloc, NotesState>(
              builder: (context, state) {
                if (state is NotesLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is NotesSuccess) {
                  final notes = state.notes;
                  if (notes.isEmpty) {
                    return const Center(child: Text('Нет заметок'));
                  }
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MasonryGridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      itemCount: notes.length,
                      itemBuilder: (context, index) {
                        return NoteCard(note: notes[index]);
                      },
                    ),
                  );
                } else {
                  return const Center(child: Text('Ошибка при загрузке заметок'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Настройки'),
          content: BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, mode) {
              final isDark = mode == ThemeMode.dark;
              return SwitchListTile.adaptive(
                title: const Text('Тёмная тема'),
                value: isDark,
                onChanged: (val) {
                  context.read<ThemeCubit>().toggleTheme(val);
                },
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Закрыть'),
            ),
          ],
        );
      },
    );
  }
}
