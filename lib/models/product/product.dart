import 'package:intl/intl.dart';
import 'package:pawprints/models/product/discount.dart';
import 'package:pawprints/models/product/stock_management.dart';

class Product {
  String? id;
  String? name;
  String? image;
  ProductType type;
  String? description;
  String? categoryID;
  String? features;
  String? contents;
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
    this.id,
    this.name,
    this.image,
    this.type = ProductType.GOODS,
    this.description,
    this.categoryID,
    this.features,
    this.contents,
    this.quantity = 0,
    this.visibility = false,
    this.cost = 0.0,
    this.price = 0.0,
    this.discount,
    this.expiration,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.stocks = const [],
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

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
          ? DateTime.parse(json['expiration'])
          : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
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
      'expiration': expiration?.toIso8601String(),
      'createdAt': DateFormat('yyyy-MM-ddTHH:mm:ss').format(createdAt),
      'updatedAt': DateFormat('yyyy-MM-ddTHH:mm:ss').format(updatedAt),
      'stocks': stocks.map((item) => item.toJson()).toList(),
    };
  }
}
