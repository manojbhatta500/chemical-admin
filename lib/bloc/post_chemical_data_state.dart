part of 'post_chemical_data_bloc.dart';

sealed class PostChemicalDataState extends Equatable {
  const PostChemicalDataState();

  @override
  List<Object> get props => [];
}

final class PostChemicalDataInitial extends PostChemicalDataState {}

final class PostChemicalDataLoading extends PostChemicalDataState {}

final class PostChemicalDataSuccess extends PostChemicalDataState {}

final class PostChemicalDataFailed extends PostChemicalDataState {}
