import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Cart {
  String? id;
  String? userID;
  String? productID;
  int quantity;
  double price;
  DateTime addedAt;

  Cart({
    required this.id,
    required this.userID,
    required this.productID,
    required this.quantity,
    required this.price,
    required DateTime? addedAt,
  }) : addedAt = addedAt ?? DateTime.now();

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'],
      userID: json['userID'],
      productID: json['productID'],
      quantity: json['quantity'],
      price: json['price'],
      addedAt: (json['addedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userID': userID,
      'productID': productID,
      'quantity': quantity,
      'price': price,
      'addedAt': Timestamp.fromDate(addedAt),
    };
  }
}
