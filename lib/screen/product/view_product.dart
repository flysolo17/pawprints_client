import 'package:flutter/material.dart';
import 'package:pawprints/models/product/stock_management.dart';
import 'package:pawprints/services/cart.service.dart';
import 'package:pawprints/services/product.service.dart';
import 'package:pawprints/ui/utils/toast.dart';

import '../../models/cart/cart.dart';
import '../../models/product/product.dart';
import '../../models/users/users.dart';
import '../../services/auth.service.dart';

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No user found'),
          backgroundColor: Colors.red,
        ),
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
        backgroundColor: const Color(0xFF1A237E), // Pawprints theme color
        title: Row(
          children: const [
            Icon(Icons.pets, color: Colors.white), // Paw print logo
            SizedBox(width: 10),
            Text('Product Details'),
          ],
        ),
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

          final product = snapshot.data!;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.network(
                          product.image,
                          height: 250,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: Icon(
                            Icons.pets,
                            color: Colors.white.withOpacity(0.8),
                            size: 40,
                          ), // Paw print overlay
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                product.name,
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.pets, color: Colors.teal),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Price: ₱${product.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Description:',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            product.description,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 20),
                          if (product.type == ProductType.GOODS)
                            ElevatedButton.icon(
                              onPressed: () {
                                addToCart(product);
                              },
                              icon: const Icon(Icons.shopping_cart),
                              label: const Text("Add to Cart"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                              ),
                            )
                          else
                            ElevatedButton.icon(
                              onPressed: () {
                                // Add functionality for appointments
                              },
                              icon: const Icon(Icons.schedule),
                              label: const Text("Create Appointment"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 43, 180, 100),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
