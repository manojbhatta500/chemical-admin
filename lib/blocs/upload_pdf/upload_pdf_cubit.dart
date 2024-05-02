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
    required List<int> pdfbytes,
    required List<int> imagebytes,
  }) async {
    ApiService manager = ApiService();
    emit(UploadPdfPending());

    final repoResponse = await manager.uploadData(
        commonName: commonName,
        scientificName: scientificName,
        categoryId: categoryId,
        pdfBytes: pdfbytes,
        imageBytes: imagebytes);

    if (repoResponse == true) {
      emit(UploadPdfSuccess());
    } else {
      emit(UploadPdfFailed());
    }
  }
}
