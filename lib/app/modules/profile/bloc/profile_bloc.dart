import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:next_chat/app/services/cloudinary_service.dart';
import 'package:next_chat/app/services/firebase_user_profile_service.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ImagePicker _imagePicker = ImagePicker();
  final FirebaseUserProfileService firebaseUserProfileService;
  final CloudinaryService cloudinaryService;
  ProfileBloc({
    required this.firebaseUserProfileService,
    required this.cloudinaryService,
  }) : super(ProfileInitial()) {
    on<PickProfileImageEvent>(pickProfileImageEvent);
    on<UpdateProfileEvent>(updateProfileEvent);
    on<LoadProfileEvent>(loadProfileEvent);
  }

  FutureOr<void> pickProfileImageEvent(
    PickProfileImageEvent event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      debugPrint('ProfileBloc received: ${event.imageSource}');
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: event.imageSource,
        imageQuality: 85,
        maxWidth: 1200,
      );
      if (pickedFile == null) return;
      emit(ProfileImageSelectedState(image: File(pickedFile.path)));
    } catch (e) {
      emit(ProfileImageSelectedErrorState(message: e.toString()));
    }
  }

  Future<void> updateProfileEvent(
    UpdateProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(UpdateProfileLoadingState());

    try {
      String? photoUrl;

      if (event.image != null) {
        photoUrl = await cloudinaryService.uploadProfileImage(event.image!);
      }

      await firebaseUserProfileService.updateUserProfile(
        name: event.name,
        photoUrl: photoUrl,
      );

      emit(UpdateProfileSuccessState());
    } catch (e) {
      emit(UpdateProfileErrorState(message: e.toString()));
    }
  }

  Future<void> loadProfileEvent(
    LoadProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoadingState());

    try {
      final profile = await firebaseUserProfileService.getUserProfile();

      if (profile == null) {
        emit(ProfileLoadErrorState(message: 'Profile not found'));
        return;
      }

      emit(ProfileLoadedState(name: profile.name, photoUrl: profile.photoUrl));
    } catch (e) {
      emit(ProfileLoadErrorState(message: e.toString()));
    }
  }
}
