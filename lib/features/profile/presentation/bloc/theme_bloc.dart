import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucidplus_machine_task/features/profile/domain/repository/profile_repository.dart';
import 'package:lucidplus_machine_task/features/profile/presentation/bloc/theme_event.dart';
import 'package:lucidplus_machine_task/features/profile/presentation/bloc/theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final ProfileRepository repository;

  ThemeBloc(this.repository) : super(ThemeState(themeMode: ThemeMode.light)) {
    on<LoadThemeEvent>(_onLoadTheme);
    on<ToggleThemeEvent>(_onToggleTheme);
  }

  Future<void> _onLoadTheme(
    LoadThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final isDark = await repository.getThemeMode(event.userId);

    print("ISDARK:$isDark");

    emit(
      state.copyWith(
        themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
        isLoading: false,
      ),
    );
  }

  Future<void> _onToggleTheme(
    ToggleThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    emit(
      state.copyWith(
        themeMode: event.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      ),
    );

    await repository.updateThemeMode(
      userId: event.userId,
      isDarkMode: event.isDarkMode,
    );
  }
}
