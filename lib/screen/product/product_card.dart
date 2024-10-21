import 'package:flutter/material.dart';
import 'package:pawprints/models/product/product.dart';

import '../../models/product/stock_management.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onAddToCart;
  final VoidCallback onTap;
  const ProductCard(
      {super.key,
      required this.product,
      required this.onAddToCart,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          onTap();
        },
        child: Column(
          children: [
            Image.network(
              product.image!,
              width: double.infinity,
              height: 180,
              fit: BoxFit.cover, // Center crop effect
            ),
            ListTile(
              title: Text("${product.name}"),
              subtitle: Text(
                "${product.price.toStringAsFixed(2)}",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: product.type == ProductType.GOODS
                  ? IconButton(
                      onPressed: () {
                        onAddToCart();
                      },
                      icon: const Icon(Icons.shopping_cart),
                    )
                  : null,
            )
          ],
        ),
      ),
    );
  }
}
