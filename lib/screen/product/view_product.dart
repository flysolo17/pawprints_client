import 'package:flutter/material.dart';
import 'package:pawprints/models/product/stock_management.dart';
import 'package:pawprints/services/cart.service.dart';
import 'package:pawprints/services/product.service.dart';

import '../../models/cart/cart.dart';
import '../../models/product/product.dart';
import '../../models/users/users.dart';
import '../../services/auth.service.dart';
import '../../ui/utils/toast.dart';

class ViewProduct extends StatefulWidget {
  final String id;
  const ViewProduct({super.key, required this.id});

  @override
  State<ViewProduct> createState() => _ViewProductState();
}

class _ViewProductState extends State<ViewProduct> {
  final ProductService productService = ProductService();
  final CartService cartService = CartService();
  late AuthService authService = AuthService();
  Users? users;
  void initializeUser() async {
    Users? user = await authService.getUser();
    setState(() {
      users = user;
    });
  }

  void addToCart(Product product) {
    if (users == null) {
      const SnackBar(
        content: Text('No Users found'),
        backgroundColor: Colors.red,
      );
      return;
    }
    Cart cart = Cart(
      id: generateRandomNumber(maxLength: 10).toString(),
      userID: users!.id,
      productID: product.id,
      quantity: 1,
      price: product.price,
      addedAt: DateTime.now(),
    );

    cartService.addToCart(cart).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added ${product.name} to cart'),
          backgroundColor: Colors.green,
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add ${product.name} to cart: $error'),
          backgroundColor: Colors.red,
        ),
      );
    });
  }

  @override
  void initState() {
    initializeUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        actionsIconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(color: Colors.white),
        backgroundColor: const Color(0xFF001B44),
        title: const Text('Product Details'),
      ),
      body: FutureBuilder<Product?>(
        future: productService.getProductById(widget.id), // Fetch product by ID
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error fetching product: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Product not found'));
          }

          // Product fetched successfully
          final product = snapshot.data!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(product.image),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name, // Display product name
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Price: ₱${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Description: ${product.description}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    if (product.type == ProductType.GOODS)
                      TextButton(
                          child: Text("Add to cart"),
                          onPressed: () {
                            addToCart(product);
                          })
                    else
                      TextButton(
                          child: Text("Create Appointment"), onPressed: () {})
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
