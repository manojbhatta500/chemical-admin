import 'dart:async';

import 'package:apiadmin/reposiotory/create_category_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'create_catogery_event.dart';
part 'create_catogery_state.dart';

class CreateCatogeryBloc
    extends Bloc<CreateCatogeryEvent, CreateCatogeryState> {
  CreateCatogeryBloc() : super(CreateCatogeryInitial()) {
    on<CreateCategory>(_onCreateCategory);
  }
  CreateCategoryRepository manager = CreateCategoryRepository();
  FutureOr<void> _onCreateCategory(
      CreateCategory event, Emitter<CreateCatogeryState> emit) async {
    emit(CreateCatogeryLoading());
    final repoResponse = await manager.createCategory(event.categoryName);
    if (repoResponse == 1) {
      emit(CreateCatogerySuccess());
    } else {
      emit(CreateCatogeryFailed());
    }
  }
}
