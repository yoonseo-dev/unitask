import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  static final String _hostUrl = 'https://daelim.fleecy.dev/functions/v1';
  static final String _signupUrl = '$_hostUrl/students/signup';

  static bool _enableOnce = false; //막 클릭(중복실행)하지 못하게 함

  static Future<bool?> signup({
    required String email,
    required String password,
    required String name,
  }) async {
    if (_enableOnce) return null;
    _enableOnce = true;

    final response = await http.post(
      Uri.parse(_signupUrl),
      body: jsonEncode({"email": email, "password": password, "name": name}),
    );

    final statusCode = response.statusCode;

    _enableOnce = false;

    if (statusCode != 200) {
      return false;
    }

    return true;
  }
}
