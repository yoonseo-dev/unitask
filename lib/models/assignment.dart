// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:unitask/core/enum/assignment_status.dart';
import 'package:unitask/core/enum/priority.dart';
import 'package:unitask/models/subject.dart';

class Assignment {
  final String id;
  final String subjectId;
  final String title;
  final String? description;
  final DateTime dueDate;
  final Priority priority;
  final AssignmentStatus status;
  final DateTime? completeAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  //과목
  final Subject? subject;

  Assignment({
    required this.id,
    required this.subjectId,
    required this.title,
    this.description,
    required this.dueDate,
    required this.priority,
    required this.status,
    this.completeAt,
    this.createdAt,
    this.updatedAt,
    this.subject,
  });

  Assignment copyWith({
    String? id,
    String? subjectId,
    String? title,
    String? description,
    DateTime? dueDate,
    Priority? priority,
    AssignmentStatus? status,
    DateTime? completeAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    Subject? subject,
  }) {
    return Assignment(
      id: id ?? this.id,
      subjectId: subjectId ?? this.subjectId,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      completeAt: completeAt ?? this.completeAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      subject: subject ?? this.subject,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'subjectId': subjectId,
      'title': title,
      'description': description,
      'dueDate': dueDate.millisecondsSinceEpoch,
      'priority': priority.name,
      'status': status.name,
      'completeAt': completeAt?.millisecondsSinceEpoch,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
      'subject': subject?.toMap(),
    };
  }

  factory Assignment.fromMap(Map<String, dynamic> map) {
    return Assignment(
      id: map['id'] ?? '',
      subjectId: map['subject_id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'],
      dueDate: DateTime.parse(map['dueDate']),
      priority: Priority.values.firstWhere(map['priority']),
      status: AssignmentStatus.fromApi(map['status']),
      completeAt: map['complete_at'] != null
          ? DateTime.parse(map['completeAt'])
          : null,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['createdAt'])
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updatedAt'])
          : null,
      subject: map['subject'] != null
          ? Subject.fromMap(map['subject'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Assignment.fromJson(String source) =>
      Assignment.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Assignment(id: $id, subjectId: $subjectId, title: $title, description: $description, dueDate: $dueDate, priority: $priority, status: $status, completeAt: $completeAt, createdAt: $createdAt, updatedAt: $updatedAt, subject: $subject)';
  }

  @override
  bool operator ==(covariant Assignment other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.subjectId == subjectId &&
        other.title == title &&
        other.description == description &&
        other.dueDate == dueDate &&
        other.priority == priority &&
        other.status == status &&
        other.completeAt == completeAt &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.subject == subject;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        subjectId.hashCode ^
        title.hashCode ^
        description.hashCode ^
        dueDate.hashCode ^
        priority.hashCode ^
        status.hashCode ^
        completeAt.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        subject.hashCode;
  }
}
