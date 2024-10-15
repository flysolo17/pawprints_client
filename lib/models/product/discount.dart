import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Discount {
  double value;
  DateTime? expiration;

  Discount({
    this.value = 0.0,
    this.expiration,
  });

  factory Discount.fromJson(Map<String, dynamic> json) {
    return Discount(
      value: json['value'],
      expiration: json['expiration'] != null
          ? (json['expiration'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'expiration': expiration != null ? Timestamp.fromDate(expiration!) : null,
    };
  }
}
