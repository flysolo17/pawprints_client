import 'package:flutter/material.dart';
import 'package:pawprints/models/product/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      // clipBehavior is necessary because, without it, the InkWell's animation
      // will extend beyond the rounded edges of the [Card] (see https://github.com/flutter/flutter/issues/109776)
      // This comes with a small performance cost, and you should not set [clipBehavior]
      // unless you need it.
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
