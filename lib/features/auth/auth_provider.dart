import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unitask/core/modles/result.dart';
import 'package:unitask/models/auth_data.dart';
import 'package:unitask/services/auth_api_service.dart';

final authApiServiceProvider = Provider<AuthApiService>(
  (ref) => AuthApiService(),
);

final authProvider = NotifierProvider<AuthProvider, AsyncValue<AuthData?>>(
  AuthProvider.new,
);

class AuthProvider extends Notifier<AsyncValue<AuthData?>> {
  @override
  AsyncValue<AuthData?> build() => const AsyncData(null);
  //여기서 null은 디폴트값이라고 생각하면 됨

  Future<Result<AuthData>> login({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();

    try {
      final result = await ref
          .read(authApiServiceProvider)
          .login(email: email, password: password);
      state = switch (result) {
        Success(:final value) => AsyncData(value),
        Failure(:final exception) => AsyncError(exception, .current),
      };

      return result;
    } on Exception catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
      return Failure(e);
    }
  }

  Future<Result<void>> signup({
    required String email,
    required String password,
    required String name,
  }) async {
    final authData = state.value;

    state = const AsyncLoading();
    //AsyncData값이 오면 로딩이 알아서 풀린다.

    try {
      final result = await ref
          .read(authApiServiceProvider)
          .signup(name: name, email: email, password: password);
      state = switch (result) {
        Success() => AsyncData(authData),
        Failure(:final exception) => AsyncError(exception, .current),
      };

      return result;
    } on Exception catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
      return Failure(e);
    }
  }
}
