import 'package:flutter_bloc/flutter_bloc.dart';

class UserState {
  final String id;
  final String name;
  final String photo;

  UserState({required this.id, required this.name, required this.photo});
}

abstract class UserEvent {}

class LoginEvent extends UserEvent {
  final String id;
  final String name;
  final String photo;

  LoginEvent({required this.id, required this.name, required this.photo});
}

class LogoutEvent extends UserEvent {}

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserState(id: '', name: '', photo: '')) {
    on<LoginEvent>((event, emit) =>
        emit(UserState(id: event.id, name: event.name, photo: event.photo)));
    on<LogoutEvent>(
        (event, emit) => emit(UserState(id: '', name: '', photo: '')));
  }
}
