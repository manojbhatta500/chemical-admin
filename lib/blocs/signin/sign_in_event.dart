part of 'sign_in_bloc.dart';

sealed class SignInEvent extends Equatable {
  const SignInEvent();

  @override
  List<Object> get props => [];
}

final class OnSignInEvent extends SignInEvent {
  final String userName;
  final String password;
  OnSignInEvent({required this.userName, required this.password});
}
