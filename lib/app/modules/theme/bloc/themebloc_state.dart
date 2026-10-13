part of 'themebloc_bloc.dart';

@immutable
sealed class ThemeblocState {}

abstract class ThemeActionState extends ThemeblocState {}

final class ThemeblocInitial extends ThemeblocState {}

final class ThemeChangesSuccessState extends ThemeblocState {
  final bool isDarkMode;

  ThemeChangesSuccessState({required this.isDarkMode});
}

final class ThemeChangesSuccessMessage extends ThemeActionState {
  final String message;

  ThemeChangesSuccessMessage({required this.message});
}
