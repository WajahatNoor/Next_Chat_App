import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:next_chat/app/modules/auth/bloc/auth_bloc.dart'
    show AuthBloc, LogoutAccountEvent;
import 'package:next_chat/app/res/app_colors.dart';

class AppDialogs {
  static void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: const Text(
            "Logout",
            style: TextStyle(
              color: AppColors.textColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: const Text(
            "Would you like to logout?",
            style: TextStyle(color: AppColors.secondaryText),
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.pop();
              },
              child: const Text(
                "Cancel",
                style: TextStyle(color: AppColors.secondaryText),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                context.pop();

                context.read<AuthBloc>().add(LogoutAccountEvent());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.surface,
                elevation: 0,
              ),
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );
  }
}
