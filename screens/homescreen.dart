import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/order.dart';
import '../models/cart.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import '../services/providers.dart';
import 'cart_screen.dart';
import 'orders_screen.dart';
import 'products_card.dart';
import 'profile_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  final List<Order>? orders;

  HomeScreen({this.orders});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;
  List<Order> _orders = [];
  List<CartItem> _cartItems = [];

  @override
  void initState() {
    super.initState();
    if (widget.orders != null) {
      _orders = widget.orders!; // Initialize orders if passed
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _addToCart(Product product, int quantity) {
    setState(() {
      final existingCartItem = _cartItems.firstWhere(
        (item) => item.product.id == product.id,
        orElse: () => CartItem(product, 0),
      );

      if (existingCartItem.quantity > 0) {
        existingCartItem.quantity += quantity;
      } else {
        _cartItems.add(CartItem(product, quantity));
      }
    });

    // Navigate to CartScreen after adding item
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CartScreen(cartItems: _cartItems, onCheckout: _checkout),
      ),
    );
  }

  void _checkout(List<Order> orders) {
    setState(() {
      _orders.addAll(orders); // Add new orders to the existing list
      _cartItems.clear(); // Clear the cart after checkout
    });

    // Navigate to Orders screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => OrdersScreen(orders: _orders)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productService = ref.watch(productServiceProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(['Products', 'Orders', 'Cart', 'Profile'][_selectedIndex]),
        automaticallyImplyLeading: false,
      ),
      body: _buildBody(productService),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBody(ProductService productService) {
    switch (_selectedIndex) {
      case 0:
        return _buildProductGrid(productService);
      case 1:
        return OrdersScreen(orders: _orders); // Pass orders to OrdersScreen
      case 2:
        return CartScreen(cartItems: _cartItems, onCheckout: _checkout);
      default:
        return ProfileScreen();
    }
  }

  Widget _buildProductGrid(ProductService productService) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
      ),
      itemCount: productService.getProducts().length,
      itemBuilder: (context, index) {
        final product = productService.getProducts()[index];
        return ProductCard(product: product, addToCart: _addToCart);
      },
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Products'),
        BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Orders'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      selectedItemColor: Colors.blue,
      unselectedItemColor: const Color.fromARGB(255, 0, 0, 0),
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
    );
  }
}
