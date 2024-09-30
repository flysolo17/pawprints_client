import 'package:pawprints/models/doctor/hours.dart';

class Schedule {
  String? id;
  String? doctorID;
  Hours? startTime;
  Hours? endTime;
  List<String> days;

  Schedule({
    this.id,
    this.doctorID,
    this.startTime,
    this.endTime,
    this.days = const [],
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json['id'],
      doctorID: json['doctorID'],
      startTime:
          json['startTime'] != null ? Hours.fromJson(json['startTime']) : null,
      endTime: json['endTime'] != null ? Hours.fromJson(json['endTime']) : null,
      days: List<String>.from(json['days']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctorID': doctorID,
      'startTime': startTime?.toJson(),
      'endTime': endTime?.toJson(),
      'days': days,
    };
  }
}
