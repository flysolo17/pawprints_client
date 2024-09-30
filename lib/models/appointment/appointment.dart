import 'package:intl/intl.dart';
import 'package:pawprints/models/appointment/appointment_status.dart';
import 'package:pawprints/models/appointment/attendee.dart';
import 'package:pawprints/models/doctor/hours.dart';

class Appointment {
  String? id;
  String? title;
  String? note;
  List<Attendee> attendees;
  String? scheduleDate;
  Hours? startTime;
  Hours? endTime;
  AppointmentStatus? status;
  DateTime createdAt;
  DateTime updatedAt;

  Appointment({
    this.id,
    this.title,
    this.note,
    this.attendees = const [],
    this.scheduleDate,
    this.startTime,
    this.endTime,
    this.status,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      title: json['title'],
      note: json['note'],
      attendees: (json['attendees'] as List)
          .map((item) => Attendee.fromJson(item))
          .toList(),
      scheduleDate: json['scheduleDate'],
      startTime: Hours.fromJson(json['startTime']),
      endTime: Hours.fromJson(json['endTime']),
      status: AppointmentStatus.values.byName(json['status']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'note': note,
      'attendees': attendees.map((item) => item.toJson()).toList(),
      'scheduleDate': scheduleDate,
      'startTime': startTime?.toJson(),
      'endTime': endTime?.toJson(),
      'status': status?.name,
      'createdAt': DateFormat('yyyy-MM-ddTHH:mm:ss').format(createdAt),
      'updatedAt': DateFormat('yyyy-MM-ddTHH:mm:ss').format(updatedAt),
    };
  }
}
