import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:unitask/app/app_strings.dart';
import 'package:unitask/core/enum/priority.dart';
import 'package:unitask/core/modles/result.dart';
import 'package:unitask/models/assignment.dart';

class AssignmentApiService {
  final String _baseUrl = '${AppStrings.apiHostUrl}/assignments';

  Map<String, String> _headers(String accessToken) => {
    HttpHeaders.authorizationHeader: 'Bearer $accessToken',
    HttpHeaders.contentTypeHeader: 'application/json',
  };

  //GET /assingments => 목록 조회
  Future<Result<List<Assignment>>> fetchAll(String accessToken) async {
    try {
      //
      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: _headers(accessToken),
      );
      if (response.statusCode != 200) {
        throw Exception('과제 목록을 불러오지 못했습니다.');
      }

      final list = (json.decode(response.body) as List)
          .map((e) => Assignment.fromMap(e as Map<String, dynamic>))
          .toList();

      return Success(list);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  //GET /assingments/{id}
  Future<Result<Assignment>> fetchOne({
    required String accessToken,
    required String id,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/$id'),
        headers: _headers(accessToken),
      );

      if (response.statusCode != 200) {
        throw Exception('과제를 불러오지 못했습니다.');
      }

      return Success(Assignment.fromJson(response.body));
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  //POST /assignments => 과제 추가
  Future<Result<Assignment>> create({
    required String accessToken,
    required String subjectId,
    required String title,
    String? description,
    required DateTime dueDate,
    Priority priority = .medium,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: _headers(accessToken),
        body: jsonEncode({
          'subject_id': subjectId,
          'title': title,
          'description': description,
          'due_date': dueDate.toIso8601String(),
          'priority': priority.name,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('과제 생성을 실패했습니다.');
      }

      return Success(Assignment.fromJson(response.body));
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  //PATCH /assignments/{id} => 과제 수정
  Future<Result<Assignment>> update({
    required String accessToken,
    required String id,
    String? subjectId,
    String? title,
    String? description,
    DateTime? dueDate,
    Priority? priority,
  }) async {
    try {
      final response = await http.patch(
        Uri.parse('$_baseUrl/$id'),
        headers: _headers(accessToken),
        body: jsonEncode({
          'subject_id': ?subjectId,
          'title': ?title,
          'description': ?description,
          'due_date': ?dueDate?.toIso8601String(),
          'priority': ?priority?.name,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('과제 수정을 실패했습니다.');
      }

      return Success(Assignment.fromJson(response.body));
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  //DELETE /assignments/{id} => 과제 삭제
  Future<Result<void>> delete({
    required String accessToken,
    required String id,
  }) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/$id'),
        headers: _headers(accessToken),
      );

      if (response.statusCode != 200) {
        throw Exception('과제 삭제를 실패했습니다.');
      }

      return Success(null);
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
