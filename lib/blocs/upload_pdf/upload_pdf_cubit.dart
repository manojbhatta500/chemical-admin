import 'dart:io';

import 'package:apiadmin/reposiotory/add_chemical_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'upload_pdf_state.dart';

class UploadPdfCubit extends Cubit<UploadPdfState> {
  UploadPdfCubit() : super(UploadPdfInitial());

  void hitPostServer({
    required String commonName,
    required String scientificName,
    required String categoryId,
    required File file,
    required File image,
  }) async {
    ChemicalRepository manager = ChemicalRepository();
    emit(UploadPdfPending());

    final repoResponse = await manager.postChemical(
        commonName: commonName,
        scientificName: scientificName,
        categoryId: categoryId,
        file: file,
        image: image);

    if (repoResponse == true) {
      emit(UploadPdfSuccess());
    } else {
      emit(UploadPdfFailed());
    }
  }
}
