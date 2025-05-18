import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_task/core/injector/di.dart';
import 'package:notes_task/core/router/routes.dart';
import 'package:notes_task/features/notes/presentation/bloc/notes/notes_bloc.dart';

import '../../../core/theme/theme.dart';
import 'bloc/theme_cubit.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return BlocProvider(
      create: (context) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            routerDelegate: route.routerDelegate,
            routeInformationParser: route.routeInformationParser,
            routeInformationProvider: route.routeInformationProvider,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            debugShowCheckedModeBanner: false,
            builder: (context, child) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (_) =>
                    NotesBloc(getIt())
                      ..add(LoadNotesEvent()),
                  ),
                ],
                child: child!,
              );
            },
          );
        },
      ),
    );
  }
}
