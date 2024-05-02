import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:apiadmin/utils/apis.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

import 'package:http/http.dart' as http;

import '../utils/tokens.dart';

class ApiService {
  Future<bool> uploadData({
    required String commonName,
    required String scientificName,
    required String categoryId,
    required List<int> pdfBytes,
    required List<int> imageBytes,
  }) async {
    // Replace with your actual API endpoint
    final url = Apis.uploadPdfAPi;

    final formData = FormData.fromMap({
      'commonName': commonName,
      'scientificName': scientificName,
      'categoryId': categoryId,
      'file': MultipartFile.fromBytes(
        pdfBytes,
        filename: 'my_pdf.pdf', // Optional filename
      ),
      'image': MultipartFile.fromBytes(
        imageBytes,
        // Adjust based on image type
        filename: 'my_image.jpg', // Optional filename
      ),
    });
    log("message1");
    for (var entry in formData.fields) {
      log("${entry.key}: ${entry.value}");
    }
    for (var entry in formData.files) {
      log("${entry.key}: ${entry.value}");
    }

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
        // Assuming successful response, handle it here
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
