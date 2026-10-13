import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:next_chat/app/data/models/user_profile_model.dart';
import 'package:next_chat/app/services/firebase_user_profile_service.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final FirebaseUserProfileService firebaseUserProfileService;

  HomeBloc({required this.firebaseUserProfileService}) : super(HomeInitial()) {
    on<GetHomeDataEvent>(getHomeDataEvent);
    on<SearchUserEvent>(searchUserEvent);
    on<WatchCurrentUserProfileEvent>(watchCurrentUserProfileEvent);
  }

  FutureOr<void> getHomeDataEvent(
    GetHomeDataEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(GetHomeDataLoadingState());
    try {
      final user = await firebaseUserProfileService.getUserProfile();
      final users = await firebaseUserProfileService.getAllUsers();

      emit(
        GetHomeDataSuccessState(
          user: user,
          users: users,
          filteredusers: users,
          isnoUserfoundtofiltered: false,
        ),
      );

      add(WatchCurrentUserProfileEvent());
    } catch (e) {
      emit(GetHomeDataErrorState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> searchUserEvent(
    SearchUserEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      if (state is GetHomeDataSuccessState) {
        final currentState = state as GetHomeDataSuccessState;
        final query = event.query.trim().toLowerCase();

        if (query.isEmpty) {
          emit(
            GetHomeDataSuccessState(
              user: currentState.user,
              users: currentState.users,
              filteredusers: currentState.users,
              isnoUserfoundtofiltered: false,
            ),
          );
          return;
        }

        final filteredUser = currentState.users.where((user) {
          return user.name.toLowerCase().contains(query) ||
              user.email.toLowerCase().contains(query);
        }).toList();

        if (filteredUser.isEmpty) {
          emit(
            GetHomeDataSuccessState(
              user: currentState.user,
              users: currentState.users,
              filteredusers: filteredUser,
              isnoUserfoundtofiltered: true,
            ),
          );
          return;
        }

        emit(
          GetHomeDataSuccessState(
            user: currentState.user,
            users: currentState.users,
            filteredusers: filteredUser,
            isnoUserfoundtofiltered: false,
          ),
        );
      }
    } catch (e) {}
  }

  Future<void> watchCurrentUserProfileEvent(
    WatchCurrentUserProfileEvent event,
    Emitter<HomeState> emit,
  ) async {
    await emit.forEach<UserProfileModel?>(
      firebaseUserProfileService.watchUserProfile(),
      onData: (profile) {
        final currentState = state;

        if (currentState is GetHomeDataSuccessState) {
          return GetHomeDataSuccessState(
            user: profile,
            users: currentState.users,
            filteredusers: currentState.filteredusers,
            isnoUserfoundtofiltered: currentState.isnoUserfoundtofiltered,
          );
        }

        return currentState;
      },
      onError: (error, stackTrace) {
        return GetHomeDataErrorState(errorMessage: error.toString());
      },
    );
  }
}
