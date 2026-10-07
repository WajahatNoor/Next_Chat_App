import 'package:flutter/material.dart';

import 'package:next_chat/app/res/app_colors.dart';
import 'package:next_chat/app/res/app_images_path.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo
            Container(
              width: 86,
              height: 86,

              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(24),
              ),

              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Image.asset(AppImagesPath.chatIcon, fit: BoxFit.contain),
              ),
            ),

            const SizedBox(height: 24),

            // App Name
            const Text(
              "Next Chat",
              style: TextStyle(
                fontSize: 30,
                color: AppColors.textColor,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),

            const SizedBox(height: 8),

            // Tagline
            const Text(
              "Simple. Fast. Real-time.",
              style: TextStyle(
                fontSize: 15,
                color: AppColors.secondaryText,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 32),

            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
