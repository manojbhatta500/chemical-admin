import 'dart:developer';
import 'package:apiadmin/models/category_model.dart';
import 'package:apiadmin/utils/apis.dart';
import 'package:apiadmin/utils/tokens.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class FetchCategory {
  final Dio _dio = Dio();

  Future<Either<int, List<CategoryModel>>> fetchCategories() async {
    try {
      final response = await _dio.get(
        Apis.createCategory, // Assuming this is the endpoint to fetch categories
        options: Options(
          headers: {'Authorization': 'Bearer ${Tokens.token}'},
        ),
      );

      log(response.statusCode.toString());
      log(response.data.toString()); // Convert response data to string

      if (response.statusCode == 200) {
        print('Categories fetched successfully');
        final List<CategoryModel> categoryList = (response.data as List)
            .map((item) => CategoryModel.fromJson(item))
            .toList();
        return Right(categoryList);
      } else {
        print('Failed to fetch categories');
        return Left(0);
      }
    } catch (e) {
      print('Error fetching categories: $e');
      return Left(0);
    }
  }
}
