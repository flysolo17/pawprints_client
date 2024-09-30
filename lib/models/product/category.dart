import 'package:intl/intl.dart';

class Category {
  String? id;
  String? name;
  DateTime? createdAt;

  Category({
    this.id,
    this.name,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'createdAt': createdAt != null
          ? DateFormat('yyyy-MM-ddTHH:mm:ss').format(createdAt!)
          : null,
    };
  }
}
