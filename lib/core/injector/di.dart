
import 'package:get_it/get_it.dart';
import 'package:notes_task/features/notes/data/repository/note_repository_impl.dart';
import 'package:notes_task/features/notes/data/sources/note_source.dart';
import 'package:notes_task/features/notes/data/sources/note_source_impl.dart';
import 'package:notes_task/features/notes/domain/repository/note_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  // LocalDB
  final SharedPreferences sharedPreferences =
  await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);

  // Note
  getIt.registerLazySingleton<NoteSource>(
        () => NoteSourceImpl(sharedPreferences),
  );

  getIt.registerLazySingleton<NoteRepository>(
        () => NoteRepositoryImpl(getIt<NoteSource>()),
  );
}
