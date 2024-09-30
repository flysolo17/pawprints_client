class Hours {
  int? hour;
  int? minute;
  Meridiem? meridiem;

  Hours({
    this.hour,
    this.minute,
    this.meridiem,
  });

  factory Hours.fromJson(Map<String, dynamic> json) {
    return Hours(
      hour: json['hour'],
      minute: json['minute'],
      meridiem: Meridiem.values.byName(json['meridiem']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hour': hour,
      'minute': minute,
      'meridiem': meridiem?.name,
    };
  }
}

enum Meridiem {
  AM,
  PM,
}
