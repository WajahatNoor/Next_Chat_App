import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:next_chat/app/modules/profile/bloc/profile_bloc.dart';
import 'package:next_chat/app/res/app_colors.dart';

void showImagePickerOptions(BuildContext parentcontext) {
  showModalBottomSheet(
    context: parentcontext,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Change Profile Photo',
                style: TextStyle(
                  color: AppColors.textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Choose how you want to add your photo.',
                style: TextStyle(color: AppColors.secondaryText, fontSize: 14),
              ),
              const SizedBox(height: 20),

              ListTile(
                leading: const Icon(
                  Icons.photo_library_outlined,
                  color: AppColors.primary,
                ),
                title: const Text(
                  'Choose from Gallery',
                  style: TextStyle(color: AppColors.textColor),
                ),
                onTap: () {
                  Navigator.pop(context);
                  parentcontext.read<ProfileBloc>().add(
                    PickProfileImageEvent(imageSource: ImageSource.gallery),
                  );
                },
              ),

              ListTile(
                leading: const Icon(
                  Icons.camera_alt_outlined,
                  color: AppColors.primary,
                ),
                title: const Text(
                  'Take a Photo',
                  style: TextStyle(color: AppColors.textColor),
                ),
                onTap: () {
                  Navigator.pop(context);
                  parentcontext.read<ProfileBloc>().add(
                    PickProfileImageEvent(imageSource: ImageSource.camera),
                  );
                },
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      );
    },
  );
}
