import 'dart:async';

import 'package:apiadmin/reposiotory/admin_signin.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc() : super(SignInInitial()) {
    on<OnSignInEvent>(_onSignInEvent);
  }

  AdminSignIn manager = AdminSignIn();

  FutureOr<void> _onSignInEvent(
      OnSignInEvent event, Emitter<SignInState> emit) async {
    final userName = event.userName;
    final passWord = event.password;
    emit(SignInLoading());

    final response = await manager.AdminSignInFunction(userName, passWord);

    if (response == 1) {
      emit(SignInSuccess());
    } else {
      emit(SignInFailed());
    }
  }
}
