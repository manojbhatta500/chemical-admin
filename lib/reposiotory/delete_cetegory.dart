import 'dart:convert';

import 'package:apiadmin/models/signin.dart';
import 'package:apiadmin/utils/apis.dart';
import 'package:apiadmin/utils/tokens.dart';
import 'package:http/http.dart' as http;

class DeleteCategory {
  Future<bool> deleteCategory(String categoryId) async {
    try {
      var response = await http.delete(
        Uri.parse('${Apis.createCategory}${categoryId}'),
        headers: {'Authorization': 'Bearer ${Tokens.token}'},
      );

      print('this is repo code deleteCategory response ${response}');

      print(
          'this is repo code deleteCategory statuscode ${response.statusCode}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      } else {
        print('Failed to delete the repository: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      print('Error: $error');
      return false;
    }
  }
}
