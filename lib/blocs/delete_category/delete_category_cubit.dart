import 'package:apiadmin/reposiotory/delete_cetegory.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'delete_category_state.dart';

class DeleteCategoryCubit extends Cubit<DeleteCategoryState> {
  DeleteCategoryCubit() : super(DeleteCategoryInitial());

  DeleteCategory manager = DeleteCategory();

  void deleteCategorycubit(String id) async {
    emit(DeleteCategoryLoading());
    final repoResponse = await manager.deleteCategory(id);

    if (repoResponse == true) {
      emit(DeleteCategorySuccess());
    } else {
      emit(DeleteCategoryFailed());
    }
  }
}
