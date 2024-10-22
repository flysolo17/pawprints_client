import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pawprints/models/product/product.dart';
import 'package:pawprints/ui/utils/rounded_image.dart';

class ServicesCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  const ServicesCard({super.key, required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      child: ListTile(
        onTap: onTap,
        leading: RoundedImage(imageUrl: product.image),
        title: Text(
          product.name.toUpperCase(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(product.description),
        trailing: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
