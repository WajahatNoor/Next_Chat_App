import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:next_chat/app/modules/profile/bloc/profile_bloc.dart';
import 'package:next_chat/app/modules/profile/widgets/profile_image_picker_sheet.dart';
import 'package:next_chat/app/res/app_colors.dart';
import 'package:next_chat/app/utils/app_loader.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileBloc>().add(LoadProfileEvent());
    });
  }

  String? photoUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: AppColors.textColor,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        surfaceTintColor: Theme.of(context).colorScheme.onSurface,
        iconTheme: const IconThemeData(color: AppColors.textColor),
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoadedState) {
            _nameController.text = state.name;
            photoUrl = state.photoUrl;
          }
          if (state is ProfileLoadErrorState) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
          if (state is ProfileLoadingState) {
            AppLoader.showLoaderWithDialog();
          }
          if (state is ProfileLoadedState) {
            AppLoader.hideLoader();
          }

          if (state is UpdateProfileLoadingState) {
            AppLoader.showLoaderWithDialog();
          }
          if (state is UpdateProfileSuccessState) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
            AppLoader.hideLoader();
            context.pop();
          }
          if (state is UpdateProfileErrorState) {
            AppLoader.hideLoader();
          }
        },
        builder: (context, state) {
          final imageSelected = state is ProfileImageSelectedState;
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),

                  // Profile photo
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.35),
                              width: 2,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 54,
                            backgroundImage: imageSelected
                                ? FileImage(state.image)
                                : (photoUrl != null && photoUrl!.isNotEmpty)
                                ? NetworkImage(photoUrl!)
                                : null,
                            child:
                                !imageSelected &&
                                    (photoUrl == null || photoUrl!.isEmpty)
                                ? const Icon(Icons.person, size: 58)
                                : null,
                          ),
                        ),
                        Positioned(
                          bottom: 2,
                          right: 2,
                          child: Material(
                            color: AppColors.primary,
                            shape: const CircleBorder(),
                            child: IconButton(
                              onPressed: () => showImagePickerOptions(context),
                              tooltip: 'Change profile photo',
                              icon: Icon(
                                Icons.camera_alt_outlined,
                                color: Theme.of(context).colorScheme.surface,
                                size: 21,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  Center(
                    child: Text(
                      'Change profile photo',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 13,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    'Full Name',
                    style: TextStyle(
                      color: AppColors.textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextFormField(
                    controller: _nameController,
                    textCapitalization: TextCapitalization.words,
                    style: const TextStyle(
                      color: AppColors.textColor,
                      fontSize: 15,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Enter your name',
                      hintStyle: const TextStyle(
                        color: AppColors.secondaryText,
                      ),
                      prefixIcon: const Icon(
                        Icons.person_outline,
                        color: AppColors.secondaryText,
                      ),
                      filled: true,
                      fillColor: AppColors.surface,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: AppColors.primary,
                          width: 1.2,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        final name = _nameController.text.trim();
                        context.read<ProfileBloc>().add(
                          UpdateProfileEvent(
                            name: name,
                            image: imageSelected ? state.image : null,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Save Changes',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
