import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:next_chat/app/services/fcm_device_token_service.dart';
import 'package:next_chat/app/services/fcm_service.dart';
import 'package:next_chat/app/services/firebase_auth_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuthService firebaseAuthService;
  StreamSubscription<User?>? authSubscription;
  AuthBloc({required this.firebaseAuthService}) : super(AuthInitial()) {
    on<AuthStateChangeEvent>(onAuthStatusChanged);
    on<CreateAccountEvent>(createAccountEvent);
    on<LoginAccountEvent>(loginAccountEvent);
    on<LogoutAccountEvent>(logoutAccountEvent);

    authSubscription = firebaseAuthService.authStateChanges.listen((user) {
      add(AuthStateChangeEvent(user: user));
    });
  }

  FutureOr<void> createAccountEvent(
    CreateAccountEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthUserCreateLoadingState());
    try {
      await firebaseAuthService.registorUser(
        email: event.userEmail,
        password: event.userPassword,
        name: event.userName,
      );
    } catch (e) {
      emit(AuthUserCreateErrorState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> loginAccountEvent(
    LoginAccountEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(UserLoginLoadingState());

    try {
      await firebaseAuthService.loginUser(
        email: event.email,
        password: event.password,
      );
    } catch (e) {
      emit(UserLoginErrorState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> logoutAccountEvent(
    LogoutAccountEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(LogoutUserLoadingState());
    try {
      await Future.delayed(Duration(seconds: 4));
      await FcmTokenService.instance.removeCurrentToken();
      await firebaseAuthService.logoutUser();
    } catch (e) {
      emit(LogoutUserErrorState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> onAuthStatusChanged(
    AuthStateChangeEvent event,
    Emitter<AuthState> emit,
  ) async {
    await Future.delayed(Duration(seconds: 5));
    if (event.user != null) {
      final token = await FcmService.instance.getDeviceToken();

      if (token != null) {
        await FcmTokenService.instance.registerToken(token);
      }
      emit(AuthenticatedState());
    } else {
      emit(UnauthenticatedState());
    }
  }

  @override
  Future<void> close() {
    authSubscription?.cancel();
    return super.close();
  }
}
