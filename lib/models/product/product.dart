import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pawprints/models/product/discount.dart';
import 'package:pawprints/models/product/stock_management.dart';

class Product {
  String id;
  String name;
  String image;
  ProductType type;
  String description;
  String categoryID;
  String features;
  String contents;
  int quantity;
  bool visibility;
  double cost;
  double price;
  Discount? discount;
  DateTime? expiration;
  DateTime createdAt;
  DateTime updatedAt;
  List<StockManagement> stocks;

  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.type,
    required this.description,
    required this.categoryID,
    required this.features,
    required this.contents,
    required this.quantity,
    required this.visibility,
    required this.cost,
    required this.price,
    required this.discount,
    required this.expiration,
    required this.createdAt,
    required this.updatedAt,
    required this.stocks,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      type: ProductType.values.byName(json['type']),
      description: json['description'],
      categoryID: json['categoryID'],
      features: json['features'],
      contents: json['contents'],
      quantity: json['quantity'],
      visibility: json['visibility'],
      cost: json['cost'],
      price: json['price'],
      discount:
          json['discount'] != null ? Discount.fromJson(json['discount']) : null,
      expiration: json['expiration'] != null
          ? (json['expiration'] as Timestamp).toDate()
          : null,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
      stocks: (json['stocks'] as List)
          .map((item) => StockManagement.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'type': type.name,
      'description': description,
      'categoryID': categoryID,
      'features': features,
      'contents': contents,
      'quantity': quantity,
      'visibility': visibility,
      'cost': cost,
      'price': price,
      'discount': discount?.toJson(),
      'expiration': expiration != null ? Timestamp.fromDate(expiration!) : null,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'stocks': stocks.map((item) => item.toJson()).toList(),
    };
  }
}
