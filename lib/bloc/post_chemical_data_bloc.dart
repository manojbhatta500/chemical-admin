import 'dart:async';

import 'package:apiadmin/reposiotory/post_chemical_data_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'post_chemical_data_event.dart';
part 'post_chemical_data_state.dart';

class PostChemicalDataBloc
    extends Bloc<PostChemicalDataEvent, PostChemicalDataState> {
  PostChemicalDataBloc() : super(PostChemicalDataInitial()) {
    on<OnCreatePdfBUttonPressed>(_onButtonPressed);
  }
  PostChemicalDataRepository manager = PostChemicalDataRepository();

  FutureOr<void> _onButtonPressed(OnCreatePdfBUttonPressed event,
      Emitter<PostChemicalDataState> emit) async {
    emit(PostChemicalDataLoading());
    final repoResponse = await manager.postChemicalData(
        cName: event.cName,
        sName: event.sName,
        filePath: event.pdfPath,
        fileName: event.pdfName);
    if (repoResponse == 1) {
      emit(PostChemicalDataSuccess());
    } else {
      emit(PostChemicalDataFailed());
    }
  }
}
