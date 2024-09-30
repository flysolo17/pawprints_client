class Attendee {
  String? id;
  String? name;
  String? phone;
  String? email;
  AttendeeType? type;

  Attendee({
    this.id,
    this.name,
    this.phone,
    this.email,
    this.type = AttendeeType.CLIENT,
  });

  factory Attendee.fromJson(Map<String, dynamic> json) {
    return Attendee(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      type: AttendeeType.values.byName(json['type']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'type': type?.name,
    };
  }
}

enum AttendeeType {
  CLIENT,
  DOCTOR,
}
