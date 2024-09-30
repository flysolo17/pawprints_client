import 'package:pawprints/models/users/pet.dart';

class Users {
  String? id;
  String? name;
  String? phone;
  String? email;
  String? profile;
  List<Pet> pets;

  Users({
    this.id,
    this.name,
    this.phone,
    this.email,
    this.profile,
    this.pets = const [],
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      profile: json['profile'],
      pets: (json['pets'] as List).map((item) => Pet.fromJson(item)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'profile': profile,
      'pets': pets.map((item) => item.toJson()).toList(),
    };
  }
}
