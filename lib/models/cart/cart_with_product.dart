import '../product/product.dart';

import 'cart.dart';

class CartWithProduct {
  Cart cart;
  Product product;

  CartWithProduct({
    required this.cart,
    required this.product,
  });

  factory CartWithProduct.fromJson(Map<String, dynamic> json) {
    return CartWithProduct(
      cart: Cart.fromJson(json['cart']),
      product: Product.fromJson(json['product']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cart': cart.toJson(),
      'product': product.toJson(),
    };
  }
}
