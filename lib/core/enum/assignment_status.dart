//priority.dart 의 extenstion과 동일한 기능을 함

enum AssignmentStatus {
  inProgress,
  completed;

  String get apiValue => switch (this) {
    .inProgress => 'in_progress',
    .completed => 'completed',
  };

  bool get isCompleted => this == .completed;

  static AssignmentStatus fromApi(String value) =>
      value == 'completed' ? .completed : .inProgress;
}
