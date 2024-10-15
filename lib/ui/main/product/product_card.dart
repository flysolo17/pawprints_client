import 'package:flutter/material.dart';
import 'package:pawprints/models/product/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          debugPrint('Card tapped.');
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
            )
          ],
        ),
      ),
    );
  }
}
