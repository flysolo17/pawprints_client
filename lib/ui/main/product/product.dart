import 'package:flutter/material.dart';
import 'package:pawprints/models/cart/cart.dart';
import 'package:pawprints/models/product/product.dart';
import 'package:pawprints/models/product/stock_management.dart';
import 'package:pawprints/services/auth.service.dart';
import 'package:pawprints/services/cart.service.dart';
import 'package:pawprints/services/product.service.dart';
import 'package:pawprints/ui/main/product/product_card.dart';
import 'package:pawprints/ui/utils/toast.dart';

import '../../../models/users/users.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ProductService _productService = ProductService();

    return FutureBuilder(
      future: _productService.getAllProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error?.toString() ?? "Error getting products"),
          );
        } else if (snapshot.hasData) {
          var products = snapshot.data ?? [];
          return ProductTabs(products: products);
        } else {
          return const Center(child: Text('No products found'));
        }
      },
    );
  }
}

class ProductTabs extends StatefulWidget {
  final List<Product> products;
  const ProductTabs({super.key, required this.products});

  @override
  State<ProductTabs> createState() => _ProductTabsState();
}

class _ProductTabsState extends State<ProductTabs> {
  final AuthService _authService = AuthService();

  ProductType selectedType = ProductType.SERVICES;
  Users? _users;
  CartService _cartService = CartService();

  void addToCart(Product product) {
    if (_users == null) {
      return;
    }
    Cart cart = Cart(
        id: generateRandomNumber(maxLength: 10),
        userID: _users?.id ?? "",
        productID: product.id,
        quantity: 1,
        price: product.price,
        addedAt: DateTime.now());
    _cartService.addToCart(cart).then((_) {
      showToast(context, "Succesffully Added");
    }).catchError((err) {
      showToast(context, "Failed to add ${product.name} to cart: $err");
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeUser();
  }

  void _initializeUser() async {
    Users? user = await _authService.getUser();
    setState(() {
      _users = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Product> filteredProducts = widget.products
        .where((product) => product.type == selectedType)
        .toList();

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    selectedType = ProductType.SERVICES;
                  });
                },
                style: TextButton.styleFrom(
                  foregroundColor: selectedType == ProductType.SERVICES
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurface,
                ),
                child: Column(
                  children: [
                    const Text('Services'),
                    if (selectedType == ProductType.SERVICES)
                      Container(
                        margin: const EdgeInsets.only(top: 2.0),
                        height: 4.0,
                        width: 4.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    selectedType = ProductType.GOODS;
                  });
                },
                style: TextButton.styleFrom(
                  foregroundColor: selectedType == ProductType.GOODS
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurface,
                ),
                child: Column(
                  children: [
                    const Text('Products'),
                    if (selectedType == ProductType.GOODS)
                      Container(
                        margin: const EdgeInsets.only(top: 2.0),
                        height: 4.0,
                        width: 4.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          ProductList(
            products: filteredProducts,
            addToCart: (Product product) {
              addToCart(product);
            },
          )
        ],
      ),
    );
  }
}

class ProductList extends StatelessWidget {
  final List<Product> products;
  final void Function(Product) addToCart;
  const ProductList(
      {super.key, required this.products, required this.addToCart});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      shrinkWrap: true, // Add this to wrap content
      physics:
          const NeverScrollableScrollPhysics(), // Disable internal scrolling
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCard(
          product: product,
          onTap: () {
            addToCart(product);
          },
        );
      },
    );
  }
}
