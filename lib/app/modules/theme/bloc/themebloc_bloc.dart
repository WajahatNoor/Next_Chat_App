import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'themebloc_event.dart';
part 'themebloc_state.dart';

class ThemeblocBloc extends Bloc<ThemeblocEvent, ThemeblocState> {
  ThemeblocBloc() : super(ThemeblocInitial()) {
    on<ThemeChangeEvent>(themeChangeEvent);
  }

  FutureOr<void> themeChangeEvent(
    ThemeChangeEvent event,
    Emitter<ThemeblocState> emit,
  ) {
    emit(ThemeChangesSuccessMessage(message: "Mode Updated Successfully"));
    emit(ThemeChangesSuccessState(isDarkMode: event.isDarkMode));
  }
}
