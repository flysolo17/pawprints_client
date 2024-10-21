import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pawprints/config/router.dart';
import 'package:pawprints/models/cart/cart.dart';

import 'package:pawprints/models/cart/cart_with_product.dart';
import 'package:pawprints/models/doctor/doctor.dart';
import 'package:pawprints/ui/utils/rounded_image.dart';

import '../../services/cart.service.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartService _cartService = CartService();

  List<CartWithProduct> cartItems = [];
  void increment(CartWithProduct cart) {
    if (cart.cart.quantity < cart.product.quantity) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You have reached the maximum limit")),
      );
      return;
    }
    _cartService.increaseQuantity(cart.cart.id!).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Quantity increased")),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to increase quantity: $error")),
      );
    });
  }

  void decrement(CartWithProduct cart) {
    if (cart.cart.quantity <= 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Quantity cannot be less than 1")),
      );
      return;
    }
    _cartService.decreaseQuantity(cart.cart.id!).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Quantity decreased")),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to decrease quantity: $error")),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<CartWithProduct>>(
      stream: _cartService.getCartWithProductByUserID(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error loading cart: ${snapshot.error}'),
          );
        } else if (snapshot.hasData) {
          final data = snapshot.data ?? [];
          return CartList(
            cartItems: data,
            increment: (CartWithProduct cart) => {increment(cart)},
            decrement: (CartWithProduct cart) => {decrement(cart)},
          );
        } else {
          return const Center(child: Text('No items in the cart'));
        }
      },
    );
  }
}

class CartList extends StatefulWidget {
  final List<CartWithProduct> cartItems;
  final ValueChanged<CartWithProduct> increment;
  final ValueChanged<CartWithProduct> decrement;
  const CartList(
      {super.key,
      required this.cartItems,
      required this.increment,
      required this.decrement});

  @override
  State<CartList> createState() => _CartListState();
}

class _CartListState extends State<CartList> {
  List<CartWithProduct> cartItems = [];
  List<String> selectedItems = [];

  @override
  void initState() {
    cartItems = widget.cartItems;
    super.initState();
  }

  @override
  void didUpdateWidget(CartList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.cartItems != oldWidget.cartItems) {
      setState(() {
        cartItems = widget.cartItems;
      });
    }
  }

  void select(CartWithProduct cart, bool isSelected) {
    setState(() {
      if (isSelected) {
        selectedItems.add(cart.cart.id!);
      } else {
        selectedItems.remove(cart.cart.id);
      }
      print(selectedItems);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              final cart = cartItems[index];
              bool isSelected = selectedItems.contains(cart.cart.id);
              return CartCard(
                cart: cart,
                isSelected: isSelected,
                onSelect: (bool isSelected) {
                  select(cart, isSelected);
                },
                onAdd: () {
                  widget.increment(cart);
                },
                onMinus: () {
                  widget.decrement(cart);
                },
                viewProduct: () {
                  context.push("/product/${cart.product.id}");
                },
              );
            },
          ),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(8.0), // Define padding here
          child: SizedBox(
            width: double
                .infinity, // Set the width to infinity (fill parent width)
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Checkbox(
                  value: false,
                  onChanged: (bool? selected) => {},
                  semanticLabel: "All",
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Subtotal ${1000}"),
                    ElevatedButton(onPressed: () {}, child: Text("Checkout"))
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class CartCard extends StatelessWidget {
  final CartWithProduct cart;
  final bool isSelected;
  final VoidCallback viewProduct;
  final ValueChanged<bool> onSelect;
  final VoidCallback onAdd;
  final VoidCallback onMinus;
  const CartCard(
      {super.key,
      required this.cart,
      required this.viewProduct,
      required this.isSelected,
      required this.onSelect,
      required this.onAdd,
      required this.onMinus});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => viewProduct(),
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Checkbox(
            value: isSelected,
            onChanged: (bool? value) {
              if (value != null) {
                onSelect(value); // Pass the checkbox value
              }
            },
          ),
          RoundedImage(imageUrl: cart.product.image)
        ],
      ),
      title: Text(
        '${cart.product.name}',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 12),
      ),
      subtitle: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '₱ ${cart.cart.price.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF001B44),
            ),
          ),
          QuantityCounter(
              num: cart.cart.quantity,
              onIncrease: () => onAdd(),
              onDecrease: () => onMinus())
        ],
      ),
    );
  }
}

class QuantityCounter extends StatelessWidget {
  final int num;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  const QuantityCounter(
      {super.key,
      required this.num,
      required this.onIncrease,
      required this.onDecrease});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton.filled(
          onPressed: () => onDecrease(),
          icon: const Icon(Icons.remove),
          iconSize: 20, // Make the icon smaller
          padding:
              const EdgeInsets.all(4), // Adjust padding to make button smaller
          constraints: const BoxConstraints(
            minWidth: 24, // Define the minimum size to make it smaller
            minHeight: 24,
          ),
          style: ButtonStyle(
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0), // Set rounded corners
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 6,
        ),
        Text(num.toString()),
        const SizedBox(
          width: 6,
        ),
        IconButton.filled(
          onPressed: () => onIncrease(),
          icon: const Icon(Icons.add),
          iconSize: 20, // Make the icon smaller
          padding:
              const EdgeInsets.all(4), // Adjust padding to make button smaller
          constraints: const BoxConstraints(
            minWidth: 24, // Define the minimum size to make it smaller
            minHeight: 24,
          ),
          style: ButtonStyle(
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0), // Set rounded corners
              ),
            ),
          ),
        ),
      ],
    );
  }
}
