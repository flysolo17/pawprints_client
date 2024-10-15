import 'package:flutter/material.dart';
import 'package:pawprints/models/cart/cart_with_product.dart';

import '../../services/cart.service.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CartService _cartService = CartService();
    return FutureBuilder<List<CartWithProduct>>(
      future: _cartService.getCartWithProductByUserID(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error loading cart: ${snapshot.error}'),
          );
        } else if (snapshot.hasData) {
          var cartItems = snapshot.data ?? [];
          return ListView.builder(
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              final cart = cartItems[index];
              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    cart.product.image,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  'Product: ${cart.product.name}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                subtitle: Text('Quantity: ${cart.cart.quantity}'),
                trailing: Text(
                  '₱ ${cart.cart.price.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              );
            },
          );
        } else {
          return const Center(child: Text('No items in the cart'));
        }
      },
    );
  }
}
