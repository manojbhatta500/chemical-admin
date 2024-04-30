import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:apiadmin/utils/apis.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

import 'package:http/http.dart' as http;

import '../utils/tokens.dart';

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

  Future<bool> uploadData(
    String commonName,
    String scientificName,
    String categoryId,
    List<int>? imageBytes, // Change the type to List<int>?
    List<int>? pdfBytes, // Change the type to List<int>?
    String imageFileName,
    String pdfFileName,
  ) async {
    if (imageBytes != null || pdfBytes != null) {
      var uri = Uri.parse(Apis.uploadPdfAPi);
      var request = http.MultipartRequest('POST', uri)
        ..fields['commonName'] = commonName
        ..fields['scientificName'] = scientificName
        ..fields['categoryId'] = categoryId;

      if (pdfBytes != null) {
        var pdfFile = http.MultipartFile.fromBytes(
          'pdf_file',
          Uint8List.fromList(pdfBytes), // Convert List<int> to Uint8List
          filename: pdfFileName,
        );
        request.files.add(pdfFile);
      }

      if (imageBytes != null) {
        var imageFile = http.MultipartFile.fromBytes(
          'image_file',
          Uint8List.fromList(imageBytes), // Convert List<int> to Uint8List
          filename: imageFileName,
        );
        request.files.add(imageFile);
      }

      request.headers['Authorization'] = 'Bearer ${Tokens.token}';

      var response = await request.send();
      log(response.toString());
      log(response.statusCode.toString());

      if (response.statusCode == 200 || response.statusCode == 201) {
        print(await response.stream.bytesToString());
        return true;
      } else {
        print("Failed with status ${response.statusCode}");
        return false;
      }
    } else {
      print("Error: No files provided");
      return false;
    }
  }
}
