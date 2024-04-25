part of 'create_catogery_bloc.dart';

sealed class CreateCatogeryEvent extends Equatable {
  const CreateCatogeryEvent();

  @override
  List<Object> get props => [];
}

class CreateCategory extends CreateCatogeryEvent {
  String categoryName;
  CreateCategory({required this.categoryName});
}
