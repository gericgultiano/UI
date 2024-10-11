import 'package:flutter/material.dart';
import '../models/cart.dart';
import '../models/order.dart';
import '../models/product.dart';
import 'homescreen.dart';

class CartScreen extends StatefulWidget {
  final List<CartItem> cartItems;
  final Function(List<Order>) onCheckout;

  CartScreen({required this.cartItems, required this.onCheckout});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late List<CartItem> _cartItems;

  @override
  void initState() {
    super.initState();
    _cartItems = List.from(widget.cartItems);
  }

  void _checkout(BuildContext context) {
    final List<Order> orders = [];
    final productsWithQuantities = <Product, int>{};

    for (var cartItem in _cartItems) {
      if (cartItem.quantity > 0) {
        productsWithQuantities[cartItem.product] = cartItem.quantity;
      }
    }

    if (productsWithQuantities.isNotEmpty) {
      final order = Order(
        DateTime.now().millisecondsSinceEpoch.toString(),
        productsWithQuantities,
      );
      orders.add(order);
      widget.onCheckout(orders); // Pass orders to the checkout function

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(orders: orders),
        ),
      ); // Navigate to OrdersScreen
    }
  }

  void _updateQuantity(CartItem cartItem, int newQuantity) {
    setState(() {
      cartItem.quantity = newQuantity;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: _cartItems.isEmpty
                ? Center(child: Text('Your cart is empty.'))
                : ListView.builder(
                    itemCount: _cartItems.length,
                    itemBuilder: (context, index) {
                      return _buildCartItem(_cartItems[index]);
                    },
                  ),
          ),
          ElevatedButton(
            onPressed: () => _checkout(context),
            child: Text('Checkout'),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(CartItem cartItem) {
    return ListTile(
      title: Text(cartItem.product.name),
      subtitle: Text('₱${cartItem.product.price} x ${cartItem.quantity}'),
      trailing: Text(
          'Total: ₱${(cartItem.product.price * cartItem.quantity).toStringAsFixed(2)}'),
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.remove),
            onPressed: () {
              if (cartItem.quantity > 1) {
                _updateQuantity(cartItem, cartItem.quantity - 1);
              }
            },
          ),
          Text(cartItem.quantity.toString()),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _updateQuantity(cartItem, cartItem.quantity + 1);
            },
          ),
        ],
      ),
    );
  }
}
