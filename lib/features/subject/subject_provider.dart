import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unitask/core/modles/result.dart';
import 'package:unitask/features/auth/auth_provider.dart';
import 'package:unitask/models/subject.dart';
import 'package:unitask/services/subject_api_service.dart';

final subjectApiServiceProvider = Provider<SubjectApiService>(
  (ref) => SubjectApiService(),
);

final subjectProvider = AsyncNotifierProvider<SubjectNotifier, List<Subject>>(SubjectNotifier.new);

class SubjectNotifier extends AsyncNotifier<List<Subject>> {
  // 로그인 토큰, 미인증 시 예외처리 필요.
  String get _token {
    final token = ref.read(authProvider).value?.accessToken;
    if (token == null) throw Exception('로그인이 필요합니다.');
    return token;
  }

  SubjectApiService get _api => ref.read(subjectApiServiceProvider);

  @override
  FutureOr<List<Subject>> build() async {
    final result = await _api.fetchAll(_token);
    return switch (result) {
      Success(:final value) => value,
      Failure(:final exception) => throw exception,
    };
  }

  Future<Result<Subject>> create({required String name, String? color}) async {
    final result = await _api.create(
      accessToken: _token,
      name: name,
      color: color,
    );
    if (result is Success) ref.invalidateSelf();
    return result;
  }
}
