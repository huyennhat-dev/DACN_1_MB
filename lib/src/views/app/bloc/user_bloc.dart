import 'package:app_client/src/model/user.dart';
import 'package:app_client/src/repo/auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../helper/toast.dart';

class UserState {
  final User user;
  final bool? isLoading;

  UserState({required this.user, this.isLoading});

  UserState copyWith({User? user, bool? isLoading}) {
    return UserState(
        user: user ?? this.user, isLoading: isLoading ?? this.isLoading);
  }
}

abstract class UserEvent {}

class LoginEvent extends UserEvent {
  final User user;

  LoginEvent({required this.user});
}

class UpdateUserEvent extends UserEvent {
  final User user;
  UpdateUserEvent({required this.user});
}

class LogoutEvent extends UserEvent {}

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserState(user: User())) {
    on<LoginEvent>((event, emit) => emit(UserState(
          user: User(
              sId: event.user.sId,
              email: event.user.email,
              address: event.user.address,
              name: event.user.name,
              phone: event.user.phone,
              photo: event.user.photo),
        )));
    on<LogoutEvent>((event, emit) => emit(UserState(user: User())));
    on<UpdateUserEvent>((event, emit) => _updateUser(event, emit));
  }
  _updateUser(UpdateUserEvent event, Emitter<UserState> emit) async {
    try {
      emit(state.copyWith(isLoading: true));
      final rs = await await AuthRepo.update({
        "photo": event.user.photo,
        "name": event.user.name,
        "phone": event.user.phone,
        "address": event.user.address
      });

      emit(UserState(
        isLoading: false,
        user: User(
            sId: state.user.sId,
            email: state.user.email,
            photo: rs.data['user']['photo'],
            address: event.user.address,
            phone: event.user.phone,
            name: event.user.name),
      ));

      ToastMsg.toast("Cập nhật thành công", ToastGravity.BOTTOM);
    } catch (e) {
      throw Exception(e);
    }
  }
}
