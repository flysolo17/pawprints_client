import 'package:intl/intl.dart';

class Pet {
  String? id;
  String? name;
  String? type;
  String? breed;
  DateTime? createdAt;

  Pet({
    this.id,
    this.name,
    this.type,
    this.breed,
    this.createdAt,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      breed: json['breed'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'breed': breed,
      'createdAt': createdAt != null
          ? DateFormat('yyyy-MM-ddTHH:mm:ss').format(createdAt!)
          : null,
    };
  }
}
