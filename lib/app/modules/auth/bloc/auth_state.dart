// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

abstract class AuthActionState extends AuthState {}

final class AuthInitial extends AuthState {}

class AuthenticatedState extends AuthActionState {}

class UnauthenticatedState extends AuthActionState {}

class AuthUserCreateLoadingState extends AuthState {}

class AuthUserCreateErrorState extends AuthActionState {
  final String errorMessage;
  AuthUserCreateErrorState({required this.errorMessage});
}

class UserLoginLoadingState extends AuthState {}

class UserLoginErrorState extends AuthActionState {
  final String errorMessage;
  UserLoginErrorState({required this.errorMessage});
}

class LogoutUserLoadingState extends AuthState {}

class LogoutUserErrorState extends AuthActionState {
  final String errorMessage;
  LogoutUserErrorState({required this.errorMessage});
}
