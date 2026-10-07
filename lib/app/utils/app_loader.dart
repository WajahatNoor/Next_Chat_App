import 'package:flutter/material.dart';

import 'package:next_chat/app/res/app_colors.dart';

class AppLoader {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static void showLoaderWithDialog() {
    final context = navigatorKey.currentState?.overlay?.context;

    if (context == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.35),
      builder: (_) {
        return const PopScope(
          canPop: false,
          child: Center(
            child: SizedBox(
              width: 80,
              height: 80,
              child: Card(
                color: AppColors.surface,
                elevation: 0,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                    strokeWidth: 3,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static void hideLoader() {
    if (navigatorKey.currentState?.canPop() ?? false) {
      navigatorKey.currentState?.pop();
    }
  }
}
