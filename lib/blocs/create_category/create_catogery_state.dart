part of 'create_catogery_bloc.dart';

sealed class CreateCatogeryState extends Equatable {
  const CreateCatogeryState();

  @override
  List<Object> get props => [];
}

final class CreateCatogeryInitial extends CreateCatogeryState {}

final class CreateCatogeryLoading extends CreateCatogeryState {}

final class CreateCatogerySuccess extends CreateCatogeryState {}

final class CreateCatogeryFailed extends CreateCatogeryState {}
