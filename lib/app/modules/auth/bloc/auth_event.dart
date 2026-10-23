part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class AuthStateChangeEvent extends AuthEvent {
  final User? user;

  AuthStateChangeEvent({required this.user});
}

class CreateAccountEvent extends AuthEvent {
  final String userEmail;
  final String userPassword;
  final String userName;

  CreateAccountEvent({
    required this.userEmail,
    required this.userPassword,
    required this.userName,
  });
}

class LoginAccountEvent extends AuthEvent {
  final String email;
  final String password;

  LoginAccountEvent({required this.email, required this.password});
}

class LogoutAccountEvent extends AuthEvent {}

class SendResetPasswordEmailEvent extends AuthEvent {
  final String email;

  SendResetPasswordEmailEvent({required this.email});
}
