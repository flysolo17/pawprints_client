import 'package:intl/intl.dart';

class StockManagement {
  String message;
  int quantity;
  Movement movement;
  DateTime date;

  StockManagement({
    this.message = "",
    this.quantity = 0,
    this.movement = Movement.IN,
    DateTime? date,
  }) : date = date ?? DateTime.now();

  factory StockManagement.fromJson(Map<String, dynamic> json) {
    return StockManagement(
      message: json['message'],
      quantity: json['quantity'],
      movement: Movement.values.byName(json['movement']),
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'quantity': quantity,
      'movement': movement.name,
      'date': DateFormat('yyyy-MM-ddTHH:mm:ss').format(date),
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
