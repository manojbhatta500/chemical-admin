import 'package:apiadmin/models/category_model.dart';
import 'package:apiadmin/reposiotory/fetch_category_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'fetch_category_state.dart';

class FetchCategoryCubit extends Cubit<FetchCategoryState> {
  FetchCategoryCubit() : super(FetchCategoryInitial());

  FetchCategory manager = FetchCategory();

  void changeFetchCategoryState() async {
    emit(FetchCategoryLoading());

    final repoResponse = await manager.fetchCategories();

    repoResponse.fold((l) => {emit(FetchCategoryFailed())},
        (r) => {emit(FetchCategorySuccess(categorydata: r))});
  }
}
