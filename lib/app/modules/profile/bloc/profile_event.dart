part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent {}

class PickProfileImageEvent extends ProfileEvent {
  final ImageSource imageSource;

  PickProfileImageEvent({required this.imageSource});
}

class UpdateProfileEvent extends ProfileEvent {
  final String name;
  final File? image;

  UpdateProfileEvent({required this.name, required this.image});
}

final class LoadProfileEvent extends ProfileEvent {}
