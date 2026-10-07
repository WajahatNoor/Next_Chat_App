part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class GetHomeDataEvent extends HomeEvent {}

class SearchUserEvent extends HomeEvent {
  final String query;

  SearchUserEvent({required this.query});
}
