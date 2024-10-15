import 'package:flutter/material.dart';
import 'package:pawprints/models/product/product.dart';
import 'package:pawprints/models/product/stock_management.dart';
import 'package:pawprints/services/product.service.dart';
import 'package:pawprints/ui/main/product_card.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ProductService _productService = ProductService();

    return Scaffold(
      body: FutureBuilder(
        future: _productService.getAllProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child:
                  Text(snapshot.error?.toString() ?? "Error getting products"),
            );
          } else if (snapshot.hasData) {
            var products = snapshot.data ?? [];
            print(products.length);
            return ProductTabs(products: products);
          } else {
            return const Center(child: Text('No products found'));
          }
        },
      ),
    );
  }
}

class ProductTabs extends StatelessWidget {
  final List<Product> products;
  const ProductTabs({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(tabs: [
            Tab(
              text: "Services",
            ),
            Tab(
              text: "Products",
            )
          ]),
          Expanded(
              child: TabBarView(children: [
            ProductList(
                products: products
                    .where((e) => e.type == ProductType.SERVICES)
                    .toList()),
            ProductList(
                products: products
                    .where((e) => e.type == ProductType.GOODS)
                    .toList()),
          ]))
        ],
      ),
    );
  }
}

class ProductList extends StatelessWidget {
  final List<Product> products;
  const ProductList({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCard(product: product);
      },
    );
  }
}
