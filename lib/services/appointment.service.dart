import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:pawprints/models/appointment/appointment.dart';

import '../models/appointment/appointment_status.dart';
import '../models/doctor/hours.dart';

class AppointmentService {
  final FirebaseFirestore firestore;

  AppointmentService({
    FirebaseFirestore? firebaseFirestore,
  }) : firestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Future<void> createAppointment(Appointment appointment) async {
    try {
      await firestore
          .collection('appointments')
          .doc(appointment.id)
          .set(appointment.toJson());
    } catch (e) {
      print(e.toString());
    }
  }

  // Get appointments by user ID
  Future<List<Appointment>> getAppointmentsByUID(String uid) async {
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('appointments')
          .where('userID', isEqualTo: uid)
          .orderBy('scheduleDate')
          .get();
      return querySnapshot.docs
          .map(
              (doc) => Appointment.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  // Cancel an appointment
  Future<void> cancelAppointment(String id) async {
    try {
      await firestore.collection('appointments').doc(id).update({
        'status': AppointmentStatus.CANCELLED.name,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  // Reschedule an appointment
  Future<void> rescheduleAppointment(String id, String newScheduleDate,
      Hours newStartTime, Hours newEndTime) async {
    try {
      await firestore.collection('appointments').doc(id).update({
        'scheduleDate': newScheduleDate,
        'startTime': newStartTime.toJson(),
        'endTime': newEndTime.toJson(),
        'updatedAt': DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateTime.now()),
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
