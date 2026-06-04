import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:unitask/app/app_strings.dart';
import 'package:unitask/core/modles/result.dart';
import 'package:unitask/models/subject.dart';

class SubjectApiService {
  final String _baseUrl = '${AppStrings.apiHostUrl}/subjects';

  //토큰 활용
  Map<String, String> _headers(String accessToken) => {
    HttpHeaders.authorizationHeader: 'Bearer $accessToken',
    HttpHeaders.contentTypeHeader: 'application/json',
  };

  // GET /subjects => 목록 조회
  Future<Result<List<Subject>>> fetchAll(String accessToken) async {
    try {
      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: _headers(accessToken),
      );

      if (response.statusCode != 200) {
        throw Exception('과목 목록을 불러오지 못했습니다.');
      }

      final list = (json.decode(response.body) as List)
          .map((e) => Subject.fromMap(e as Map<String, dynamic>))
          .toList();
      return Success(list);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  //POST /subjects => 과목 추가
  Future<Result<Subject>> create({
    required String accessToken,
    required String name,
    String? color,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: _headers(accessToken),
        body: jsonEncode({
          'name': name,
          'color': ?color,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('과목 생성을 실패했습니다.');
      }

      return Success(Subject.fromJson(response.body));
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
