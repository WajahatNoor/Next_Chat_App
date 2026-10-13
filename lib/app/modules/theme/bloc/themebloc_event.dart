part of 'themebloc_bloc.dart';

@immutable
sealed class ThemeblocEvent {}

class ThemeChangeEvent extends ThemeblocEvent {
  final bool isDarkMode;

  ThemeChangeEvent({required this.isDarkMode});
}
