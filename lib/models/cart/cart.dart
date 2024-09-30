import 'package:intl/intl.dart';

class Cart {
  String? id;
  String? userID;
  String? productID;
  int quantity;
  double price;
  DateTime addedAt;

  Cart({
    this.id,
    this.userID,
    this.productID,
    this.quantity = 0,
    this.price = 0.0,
    DateTime? addedAt,
  }) : addedAt = addedAt ?? DateTime.now();

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'],
      userID: json['userID'],
      productID: json['productID'],
      quantity: json['quantity'],
      price: json['price'],
      addedAt: DateTime.parse(json['addedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userID': userID,
      'productID': productID,
      'quantity': quantity,
      'price': price,
      'addedAt': DateFormat('yyyy-MM-ddTHH:mm:ss').format(addedAt),
    };
  }
}
