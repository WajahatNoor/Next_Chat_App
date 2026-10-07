part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

class HomeActionState extends HomeState {}

final class HomeInitial extends HomeState {}

class GetHomeDataLoadingState extends HomeState {}

class GetHomeDataSuccessState extends HomeState {
  final UserProfileModel? user;
  final List<UserProfileModel> users;
  final List<UserProfileModel> filteredusers;
  final bool isnoUserfoundtofiltered;
  GetHomeDataSuccessState({
    required this.user,
    required this.users,
    required this.filteredusers,
    required this.isnoUserfoundtofiltered,
  });
}

class GetHomeDataErrorState extends HomeActionState {
  final String errorMessage;

  GetHomeDataErrorState({required this.errorMessage});
}

class NoUserFoundWithNameAndEmail extends HomeState {
  final String errorMessage;

  NoUserFoundWithNameAndEmail({required this.errorMessage});
}
