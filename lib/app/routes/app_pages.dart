import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:next_chat/app/data/models/user_profile_model.dart';
import 'package:next_chat/app/modules/auth/bloc/auth_bloc.dart';
import 'package:next_chat/app/modules/auth/views/login_screen.dart';
import 'package:next_chat/app/modules/auth/views/signup_screen.dart';
import 'package:next_chat/app/modules/chat/views/conversation_screen.dart';
import 'package:next_chat/app/modules/home/views/home_screen.dart';
import 'package:next_chat/app/modules/profile/views/edit_profile_screen.dart';
import 'package:next_chat/app/modules/splash/views/splash_screen.dart';
import 'package:next_chat/app/routes/app_routes.dart';
import 'package:next_chat/app/routes/auth_router_refresh.dart';
import 'package:next_chat/app/services/firebase_chat.dart';
import 'package:next_chat/app/utils/app_loader.dart';

class AppPages {
  static GoRouter router(AuthBloc authBloc) {
    return GoRouter(
      navigatorKey: AppLoader.navigatorKey,
      initialLocation: AppRoutes.splash,
      refreshListenable: AuthRouterRefresh(authBloc),
      redirect: (context, state) {
        final authState = authBloc.state;
        final location = state.matchedLocation;

        final isSplash = location == AppRoutes.splash;
        final isAuthPage =
            location == AppRoutes.login || location == AppRoutes.register;

        if (authState is AuthInitial) {
          return AppRoutes.splash;
        }

        if (authState is AuthenticatedState && (isAuthPage || isSplash)) {
          debugPrint("YES AUTHENTICATED");
          return AppRoutes.home;
        }
        if (authState is UnauthenticatedState && (!isAuthPage)) {
          return AppRoutes.login;
        }
        return null;
      },
      routes: [
        GoRoute(
          path: AppRoutes.splash,
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: AppRoutes.login,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: AppRoutes.register,
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: AppRoutes.home,
          builder: (context, state) => HomeScreen(),
        ),
        GoRoute(
          path: AppRoutes.editProfile,
          builder: (context, state) => EditProfileScreen(),
        ),

        GoRoute(
          path: AppRoutes.chat,
          builder: (context, state) {
            final getuser = state.extra as Map<String, dynamic>;
            final user = getuser['user'] as UserProfileModel;
            final firebaseChatService = FirebaseChat();
            return ConversationScreen(
              user: user,
              firebaseChat: firebaseChatService,
            );
          },
        ),
      ],
    );
  }
}
