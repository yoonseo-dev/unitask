# UniTask — Claude Code 시험용 가이드

## 프로젝트 개요
Flutter + Riverpod + GoRouter 기반 과제 관리 앱.
API 통신은 `http` 패키지 사용. 인증은 Bearer 토큰 방식.

## 핵심 아키텍처 패턴

### 레이어 구조
```
UI (pages/) → Provider (features/) → ApiService (services/) → 서버
```

### Result<T> 패턴 — 모든 API 반환값에 사용
```dart
// lib/core/modles/result.dart
sealed class Result<T> {}
class Success<T> extends Result<T> { final T value; }
class Failure<T> extends Result<T> { final Exception exception; }

// 사용 예시
switch (result) {
  case Success(:final value) => // 성공 처리
  case Failure(:final exception) => // 실패 처리
}
```

---

## 새 기능 추가 시 체크리스트

### 1. Model 추가 (`lib/models/xxx.dart`)
- `fromMap()`, `fromJson()`, `toMap()`, `toJson()`, `copyWith()` 구현
- `fromMap`에서 API 응답 키 이름 주의 (snake_case → camelCase 변환)

```dart
factory Xxx.fromMap(Map<String, dynamic> map) {
  return Xxx(
    id: map['id'] as String,
    name: map['name'] as String,
    // API가 snake_case면 map['some_field'], 모델은 someField
  );
}
```

### 2. ApiService 추가 (`lib/services/xxx_api_service.dart`)
```dart
class XxxApiService {
  final String _baseUrl = '${AppStrings.apiHostUrl}/endpoint';

  Map<String, String> _headers(String accessToken) => {
    HttpHeaders.authorizationHeader: 'Bearer $accessToken',
    HttpHeaders.contentTypeHeader: 'application/json',
  };

  Future<Result<List<Xxx>>> fetchAll(String accessToken) async {
    try {
      final response = await http.get(Uri.parse(_baseUrl), headers: _headers(accessToken));
      if (response.statusCode != 200) throw Exception('불러오기 실패');
      final list = (json.decode(response.body) as List)
          .map((e) => Xxx.fromMap(e as Map<String, dynamic>))
          .toList();
      return Success(list);
    } on Exception catch (e) { return Failure(e); }
  }

  Future<Result<Xxx>> create({ required String accessToken, required String name }) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: _headers(accessToken),
        body: jsonEncode({'name': name}),
      );
      if (response.statusCode != 200) throw Exception('생성 실패');
      return Success(Xxx.fromJson(response.body));
    } on Exception catch (e) { return Failure(e); }
  }
}
```

### 3. Provider 추가 (`lib/features/xxx/xxx_provider.dart`)
```dart
final xxxApiServiceProvider = Provider<XxxApiService>((ref) => XxxApiService());

final xxxProvider = AsyncNotifierProvider<XxxNotifier, List<Xxx>>(XxxNotifier.new);

class XxxNotifier extends AsyncNotifier<List<Xxx>> {
  String get _token {
    final token = ref.read(authProvider).value?.accessToken;
    if (token == null) throw Exception('로그인이 필요합니다.');
    return token;
  }

  XxxApiService get _api => ref.read(xxxApiServiceProvider);

  @override
  FutureOr<List<Xxx>> build() async {
    final result = await _api.fetchAll(_token);
    return switch (result) {
      Success(:final value) => value,
      Failure(:final exception) => throw exception,
    };
  }

  Future<Result<Xxx>> create({ required String name }) async {
    final result = await _api.create(accessToken: _token, name: name);
    if (result is Success) ref.invalidateSelf(); // 목록 자동 갱신
    return result;
  }
}
```

### 4. 새 페이지 추가
**`lib/app/router/app_page.dart`** — enum에 추가:
```dart
enum AppPage { login, signup, home, newPage } // newPage 추가
// switch 안에 .newPage => const NewPage(), 추가
```

**`lib/app/router/app_router.dart`** — 수정 없음 (AppPage enum이 자동 처리)

### 5. UI에서 Provider 사용
```dart
class XxxPage extends ConsumerStatefulWidget { ... }

class _XxxPageState extends ConsumerState<XxxPage> {
  // 상태 읽기
  final state = ref.watch(xxxProvider);

  // 로딩 여부
  final loading = ref.watch(xxxProvider).isLoading;

  // 데이터 표시
  state.when(
    data: (list) => ListView(...),
    loading: () => CircularProgressIndicator(),
    error: (e, _) => Text(e.toString()),
  );

  // 액션 호출
  Future<void> _onCreate() async {
    final result = await ref.read(xxxProvider.notifier).create(name: 'test');
    switch (result) {
      case Success() => context.showSnackbar('성공!');
      case Failure(:final exception) => context.showSnackbar(exception.toString(), isError: true);
    }
  }
}
```

---

## 인증 토큰 흐름
1. `LoginPage._onLogin()` → `authProvider.notifier.login()`
2. 성공 시 `authProvider`에 `AuthData` 저장 (accessToken 포함)
3. 다른 Provider들이 `ref.read(authProvider).value?.accessToken`으로 꺼내서 사용

---

## 자주 쓰는 패턴

### 화면 이동
```dart
context.goNamed(AppPage.home.name);   // 스택 교체 (뒤로가기 불가)
context.pushNamed(AppPage.xxx.name);  // 스택 쌓기 (뒤로가기 가능)
context.pop();                         // 뒤로가기
```

### 스낵바 (BuildContext extension)
```dart
context.showSnackbar('메시지');
context.showSnackbar('에러 메시지', isError: true); // 빨간색
```

### SizedBox 숫자 확장
```dart
20.heightBox  // SizedBox(height: 20)
20.widthBox   // SizedBox(width: 20)
```

### HTTP 메서드별 API 패턴
```dart
http.get(Uri.parse(url), headers: headers)                         // 목록/단건 조회
http.post(Uri.parse(url), headers: headers, body: jsonEncode({}))  // 생성
http.patch(Uri.parse('$url/$id'), headers: headers, body: ...)     // 수정
http.delete(Uri.parse('$url/$id'), headers: headers)               // 삭제
```

---

## 주요 파일 위치

| 역할 | 경로 |
|------|------|
| API base URL 변경 | `lib/app/app_strings.dart` |
| 라우트 추가 | `lib/app/router/app_page.dart` |
| 인증 상태 | `lib/features/auth/auth_provider.dart` |
| 과목 상태 | `lib/features/subject/subject_provider.dart` |
| 과제 상태 | `lib/features/assignment/assignment_provider.dart` |
| 공통 Result 타입 | `lib/core/modles/result.dart` |
| 공통 텍스트 필드 | `lib/ui/common/label_text_field.dart` |

---

## 주의사항
- `fromMap()`에서 API 응답의 키 이름이 snake_case인지 camelCase인지 반드시 확인
- 새 Provider 만들 때 `authProvider` import 필요 (토큰 사용 시)
- 데이터 변경 후 항상 `ref.invalidateSelf()` 호출해야 UI 갱신됨
- `ConsumerStatefulWidget` / `ConsumerWidget` 구분: 상태(Controller 등)가 필요하면 Stateful
