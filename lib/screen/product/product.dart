import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pawprints/config/router.dart';
import 'package:pawprints/models/product/product.dart';
import 'package:pawprints/models/product/stock_management.dart';
import 'package:pawprints/models/users/users.dart';
import 'package:pawprints/screen/product/product_card.dart';
import 'package:pawprints/screen/product/services_card.dart';
import 'package:pawprints/services/auth.service.dart';
import 'package:pawprints/services/cart.service.dart';
import 'package:pawprints/services/product.service.dart';

import '../../models/cart/cart.dart';
import '../../ui/utils/toast.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late ProductService _productService;
  late CartService _cartService;
  late AuthService _authService;
  Users? _users;

  @override
  void initState() {
    super.initState();
    _productService = ProductService();
    _cartService = CartService();
    _authService = AuthService();
    _initializeUser();
  }

  void _initializeUser() async {
    Users? user = await _authService.getUser();
    setState(() {
      _users = user;
    });
  }

  void addToCart(Product product) {
    if (_users == null) {
      return;
    }
    Cart cart = Cart(
      id: generateRandomNumber(maxLength: 10).toString(),
      userID: _users!.id,
      productID: product.id,
      quantity: 1,
      price: product.price,
      addedAt: DateTime.now(),
    );

    _cartService.addToCart(cart).then((_) {
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
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
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
          return ProductTabs(
            products: products,
            users: _users,
            addToCart: addToCart,
          );
        } else {
          return const Center(child: Text('No products found'));
        }
      },
    );
  }
}

class ProductTabs extends StatefulWidget {
  final List<Product> products;
  final Users? users;
  final void Function(Product) addToCart;

  const ProductTabs(
      {super.key,
      required this.products,
      required this.users,
      required this.addToCart});

  @override
  _ProductTabsState createState() => _ProductTabsState();
}

class _ProductTabsState extends State<ProductTabs> {
  ProductType selectedType = ProductType.SERVICES;

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
              _buildTabButton('Services', ProductType.SERVICES),
              _buildTabButton('Products', ProductType.GOODS),
            ],
          ),
          ProductList(products: filteredProducts, addToCart: widget.addToCart),
        ],
      ),
    );
  }

  TextButton _buildTabButton(String label, ProductType type) {
    return TextButton(
      onPressed: () {
        setState(() {
          selectedType = type;
        });
      },
      style: TextButton.styleFrom(
        foregroundColor: selectedType == type
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.onSurface,
      ),
      child: Column(
        children: [
          Text(label),
          if (selectedType == type)
            Container(
              margin: const EdgeInsets.only(top: 2.0),
              height: 4.0,
              width: 20.0,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
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
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final product = products[index];
        if (product.type == ProductType.SERVICES) {
          return ServicesCard(
              product: product,
              onTap: () => context.push('/product/${product.id}'));
        }
        return ProductCard(
          product: product,
          onAddToCart: () => addToCart(product),
          onTap: () => context.push('/product/${product.id}'),
        );
      },
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onAddToCart;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.onAddToCart,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Image.network(product.image, width: 50, height: 50),
        title: Text(product.name),
        subtitle: Text('₱${product.price.toStringAsFixed(2)}'),
        trailing: IconButton(
          icon: const Icon(Icons.add_shopping_cart),
          onPressed: onAddToCart,
        ),
        onTap: onTap,
      ),
    );
  }
}
