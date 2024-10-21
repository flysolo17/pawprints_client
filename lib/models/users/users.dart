class Users {
  String? id;
  String? name;
  String? phone;
  String? email;
  String? profile;

  Users({
    this.id,
    this.name,
    this.phone,
    this.email,
    this.profile,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      profile: json['profile'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'profile': profile,
    };
  }
}
