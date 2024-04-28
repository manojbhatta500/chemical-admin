import 'dart:io';

import 'package:dio/dio.dart';
import 'package:apiadmin/utils/apis.dart';
import 'package:apiadmin/utils/tokens.dart';

class ChemicalRepository {
  final Dio _dio = Dio();

  Future<bool> postChemical({
    required String commonName,
    required String scientificName,
    required String categoryId,
    required File file,
    required File image,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        'commonName': commonName,
        'scientificName': scientificName,
        'categoryId': categoryId,
        'pdf_file': await MultipartFile.fromFile(file.path),
        'image_file': await MultipartFile.fromFile(image.path),
      });

      final response = await _dio.post(
        Apis.uploadPdfAPi,
        data: formData,
        options: Options(
          headers: {'Authorization': 'Bearer ${Tokens.token}'},
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Assuming the server returns a success message upon successful chemical post
        return true;
      } else {
        // Handle other status codes if needed
        return false;
      }
    } catch (e) {
      print('Error posting chemical: $e');
      return false;
    }
  }
}
