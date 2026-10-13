part of 'profile_bloc.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileImageSelectedState extends ProfileState {
  final File image;

  ProfileImageSelectedState({required this.image});
}

final class ProfileImageSelectedErrorState extends ProfileState {
  final String message;

  ProfileImageSelectedErrorState({required this.message});
}

final class ProfileLoadingState extends ProfileState {}

final class ProfileLoadedState extends ProfileState {
  final String name;
  final String? photoUrl;

  ProfileLoadedState({required this.name, this.photoUrl});
}

final class ProfileLoadErrorState extends ProfileState {
  final String message;

  ProfileLoadErrorState({required this.message});
}

final class UpdateProfileLoadingState extends ProfileState {}

final class UpdateProfileSuccessState extends ProfileState {
  final String message;

  UpdateProfileSuccessState({this.message = "Profle Updated Successfully"});
}

final class UpdateProfileErrorState extends ProfileState {
  final String message;

  UpdateProfileErrorState({required this.message});
}
