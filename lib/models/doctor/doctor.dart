import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Doctor {
  String? id;
  String? profile;
  String? name;
  String? email;
  String? phone;
  int? tag;
  DateTime createdAt;

  Doctor({
    this.id,
    this.profile,
    this.name,
    this.email,
    this.phone,
    this.tag,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'],
      profile: json['profile'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      tag: json['tag'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'profile': profile,
      'name': name,
      'email': email,
      'phone': phone,
      'tag': tag,
      'createdAt': DateFormat('yyyy-MM-ddTHH:mm:ss').format(createdAt),
    };
  }
}
