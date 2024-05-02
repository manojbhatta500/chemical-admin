part of 'fetch_category_cubit.dart';

sealed class FetchCategoryState extends Equatable {
  const FetchCategoryState();

  @override
  List<Object> get props => [];
}

final class FetchCategoryInitial extends FetchCategoryState {}

final class FetchCategorySuccess extends FetchCategoryState {
  final List<CategoryModel> categorydata;
  FetchCategorySuccess({required this.categorydata});
}

final class FetchCategoryFailed extends FetchCategoryState {}

final class FetchCategoryLoading extends FetchCategoryState {}
