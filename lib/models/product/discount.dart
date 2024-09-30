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
          ? DateTime.parse(json['expiration'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'expiration': expiration != null
          ? DateFormat('yyyy-MM-ddTHH:mm:ss').format(expiration!)
          : null,
    };
  }
}
