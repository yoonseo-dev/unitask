// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Subject {
  final String id;
  final String name;
  final String color; //Hex(#00000)
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Subject({
    required this.id,
    required this.name,
    required this.color,
    this.createdAt,
    this.updatedAt,
  });

  Subject copyWith({
    String? id,
    String? name,
    String? color,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Subject(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'color': color,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
    };
  }

  factory Subject.fromMap(Map<String, dynamic> map) {
    return Subject(
      id: map['id'] as String,
      name: map['name'] as String,
      color: map['color'] as String,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['createdAt'])
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updatedAt'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Subject.fromJson(String source) =>
      Subject.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Subject(id: $id, name: $name, color: $color, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant Subject other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.color == color &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        color.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
