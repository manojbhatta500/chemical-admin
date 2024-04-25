import 'dart:convert';

import 'package:apiadmin/models/signin.dart';
import 'package:apiadmin/utils/apis.dart';
import 'package:apiadmin/utils/tokens.dart';
import 'package:http/http.dart' as http;

class AdminSignIn {
  Future<int> AdminSignInFunction(String userName, String password) async {
    print('got username ${userName}');
    print('got username ${password}');

    try {
      var response = await http.post(
        Uri.parse(Apis.signInApi),
        body: json.encode({"email": userName, "password": password}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        var data = json.decode(response.body);
        print('POST request response: $data');
        final realdata = SignInModel.fromJson(data);
        Tokens.token = realdata.accessToken!;
        return 1;
      } else {
        print('Failed to post data: ${response.statusCode}');
        return 0;
      }
    } catch (error) {
      print('Error: $error');
      return 0;
    }
  }
}
