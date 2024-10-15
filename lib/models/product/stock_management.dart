import 'package:cloud_firestore/cloud_firestore.dart';

class StockManagement {
  String message;
  int quantity;
  Movement movement;
  DateTime date;

  StockManagement({
    required this.message,
    required this.quantity,
    required this.movement,
    required this.date,
  });

  factory StockManagement.fromJson(Map<String, dynamic> json) {
    return StockManagement(
      message: json['message'],
      quantity: json['quantity'],
      movement: Movement.values.byName(json['movement']),
      date: (json['date'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'quantity': quantity,
      'movement': movement.name,
      'date': Timestamp.fromDate(date),
    };
  }
}

enum ProductType {
  GOODS,
  SERVICES,
}

enum Movement {
  IN,
  OUT,
  SOLD,
}
