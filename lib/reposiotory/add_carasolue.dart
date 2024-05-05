import 'dart:developer';

import 'package:apiadmin/utils/apis.dart';
import 'package:apiadmin/utils/tokens.dart';
import 'package:dio/dio.dart';

class AddCarasouleRepository {
  final url = Apis.uploadBanner;
  Future<bool> addCarasoule(
      String title, List<int> imageBytes, String link) async {
    final formData = FormData.fromMap({
      'title': title,
      'link': link,
      'banner': MultipartFile.fromBytes(
        imageBytes,
        // Adjust based on image type
        filename: 'carasoule_image.jpg',
      )
    });
    try {
      final response = await Dio().post(
        url,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${Tokens.token}',
            'Content-Type': 'multipart/form-data'
          },
        ),
      );
      log("message2");
      log(response.data.toString());
      log(response.statusCode.toString());

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        log('Error uploading data: ${response.data}');
        return false;
      }
    } catch (e) {
      log(e.toString());
      throw DioException(
        requestOptions: RequestOptions(
          data: e,
          validateStatus: (value) {
            log(value.toString());
            return false;
          },
        ),
      );
    }
  }
}
