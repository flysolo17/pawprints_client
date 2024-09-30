import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pawprints/services/product.service.dart';

import '../models/cart/cart.dart';
import '../models/cart/cart_with_product.dart';
import '../models/product/product.dart';

class CartService {
  final FirebaseFirestore firestore;
  final ProductService productService;
  CartService({
    FirebaseFirestore? firebaseFirestore,
    ProductService? productService,
  })  : firestore = firebaseFirestore ?? FirebaseFirestore.instance,
        productService = productService ?? ProductService();

  Future<void> addToCart(Cart cart) async {
    try {
      await firestore.collection('carts').doc(cart.id).set(cart.toJson());
    } catch (e) {
      print(e.toString());
    }
  }

  // Get cart items with product details by user ID
  Future<List<CartWithProduct>> getCartWithProductByUserID(
      String userID) async {
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('carts')
          .where('userID', isEqualTo: userID)
          .get();
      List<Cart> cartItems = querySnapshot.docs
          .map((doc) => Cart.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      List<CartWithProduct> cartWithProducts = [];
      for (Cart cart in cartItems) {
        Product? product = await productService.getProductById(cart.productID!);
        if (product != null) {
          cartWithProducts.add(CartWithProduct(cart: cart, product: product));
        }
      }
      return cartWithProducts;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  // Remove from cart
  Future<void> removeFromCart(String id) async {
    try {
      await firestore.collection('carts').doc(id).delete();
    } catch (e) {
      print(e.toString());
    }
  }
}
