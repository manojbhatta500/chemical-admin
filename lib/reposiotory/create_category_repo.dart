import 'dart:developer';

import 'package:apiadmin/utils/apis.dart';
import 'package:apiadmin/utils/tokens.dart';
import 'package:dio/dio.dart';

class CreateCategoryRepository {
  final Dio _dio = Dio();

  Future<int> createCategory(String categoryName) async {
    try {
      final response = await _dio.post(
        Apis.createCategory,
        data: {'categoryName': categoryName},
        options: Options(
          headers: {'Authorization': 'Bearer ${Tokens.token}'},
        ),
      );
      log(response.statusCode.toString());
      log(response.data.toString()); // Convert response data to string

      if (response.statusCode == 201) {
        print('Category created successfully');
        return 1;
      } else {
        print('Failed to create category');
        return 0;
      }
    } catch (e) {
      print('Error creating category: $e');
      return 0;
    }
  }
}
