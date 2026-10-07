import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:next_chat/app/data/repositories/firebase_chat_repo.dart';
import 'package:next_chat/app/modules/auth/bloc/auth_bloc.dart';
import 'package:next_chat/app/modules/chat/bloc/chat_bloc.dart';
import 'package:next_chat/app/modules/home/bloc/home_bloc.dart';
import 'package:next_chat/app/services/firebase_auth_service.dart';
import 'package:next_chat/app/services/firebase_chat.dart';
import 'package:next_chat/app/services/firebase_user_profile_service.dart';

class AllBlocProviders {
  static List<BlocProvider> providers = [
    BlocProvider<AuthBloc>(
      create: (_) => AuthBloc(firebaseAuthService: FirebaseAuthService()),
    ),
    BlocProvider<HomeBloc>(
      create: (_) =>
          HomeBloc(firebaseUserProfileService: FirebaseUserProfileService()),
    ),

    BlocProvider<ChatBloc>(
      create: (_) => ChatBloc(
        firebaseChatRepo: FirebaseChatRepo(firebaseChat: FirebaseChat()),
        firebaseChat: FirebaseChat(),
      ),
    ),
  ];
}
