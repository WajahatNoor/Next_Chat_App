import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:next_chat/app/modules/home/bloc/home_bloc.dart';
import 'package:next_chat/app/res/app_colors.dart';
import 'package:next_chat/app/routes/app_routes.dart';
import 'package:next_chat/app/utils/app_dialougs.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              BlocBuilder<HomeBloc, HomeState>(
                buildWhen: (previous, current) =>
                    current is GetHomeDataSuccessState,
                builder: (context, state) {
                  if (state is! GetHomeDataSuccessState || state.user == null) {
                    return const ListTile(
                      leading: CircleAvatar(child: Icon(Icons.person)),
                      title: Text('My Profile'),
                      subtitle: Text('Loading profile...'),
                    );
                  }

                  final user = state.user!;

                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 12,
                    ),
                    leading: CircleAvatar(
                      radius: 29,
                      backgroundColor: const Color(0xFFE8E7FF),
                      backgroundImage:
                          user.photoUrl != null && user.photoUrl!.isNotEmpty
                          ? NetworkImage(user.photoUrl!)
                          : null,
                      child: user.photoUrl == null || user.photoUrl!.isEmpty
                          ? Text(
                              user.name.isNotEmpty
                                  ? user.name[0].toUpperCase()
                                  : '?',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF5B50D6),
                              ),
                            )
                          : null,
                    ),
                    title: Text(
                      user.name.isNotEmpty ? user.name : 'Unknown User',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(
                      user.email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  );
                },
              ),

              const Divider(height: 24),

              ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text('Edit Profile'),
                onTap: () {
                  Navigator.pop(context);
                  context.push(AppRoutes.editProfile);
                },
              ),

              ListTile(
                leading: const Icon(Icons.settings_outlined),
                title: const Text('Settings'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),

              const Spacer(),

              const Divider(height: 24),

              ListTile(
                leading: Icon(Icons.logout_rounded, color: AppColors.error),
                title: const Text(
                  'Logout',
                  style: TextStyle(
                    color: AppColors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  AppDialogs.showLogoutDialog(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
