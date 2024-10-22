class Pet {
  final String id;
  final String name;
  late final String image;
  final String species;
  final String breed;
  final DateTime birthday;
  final Map<String, String> otherDetails;

  Pet({
    required this.id,
    required this.image,
    required this.name,
    required this.species,
    required this.breed,
    required this.birthday,
    required this.otherDetails,
  });

  int getAge() {
    final now = DateTime.now();
    int age = now.year - birthday.year;
    if (now.month < birthday.month ||
        (now.month == birthday.month && now.day < birthday.day)) {
      age--;
    }
    return age;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'name': name,
      'species': species,
      'breed': breed,
      'birthday': birthday.toIso8601String(),
      'otherDetails': otherDetails,
      'age': getAge(), // Optional: If you want to store age in Firestore
    };
  }

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'],
      image: json['image'],
      name: json['name'],
      species: json['species'],
      breed: json['breed'],
      birthday: DateTime.parse(json['birthday']),
      otherDetails: Map<String, String>.from(json['otherDetails']),
    );
  }
}
