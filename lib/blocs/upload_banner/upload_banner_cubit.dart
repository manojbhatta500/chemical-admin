import 'dart:developer';

import 'package:apiadmin/reposiotory/add_carasolue.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'upload_banner_state.dart';

class UploadBannerCubit extends Cubit<UploadBannerState> {
  UploadBannerCubit() : super(UploadBannerInitial());

  AddCarasouleRepository manager = AddCarasouleRepository();

  void changeUploadBannerCubit(
      String title, List<int> imageBytes, String link) async {
    emit(UploadBannerLoading());

    final repoResponse = await manager.addCarasoule(title, imageBytes, link);
    if (repoResponse == true) {
      emit(UploadBannerSuccess());
    } else if (repoResponse == false) {
      emit(UploadBannerFailed());
    } else {
      log('this is else statement statement');
      emit(UploadBannerFailed());
    }
  }
}
