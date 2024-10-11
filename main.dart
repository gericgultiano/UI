import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models/order.dart';
import 'models/cart.dart';
import 'screens/homescreen.dart';
import 'screens/orders_screen.dart';
import 'screens/login_screen.dart';
import 'screens/cart_screen.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fancy E-Commerce App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/orders': (context) => OrdersScreen(
            orders: ModalRoute.of(context)!.settings.arguments as List<Order>),
        '/cart': (context) => CartScreen(
              cartItems:
                  ModalRoute.of(context)!.settings.arguments as List<CartItem>,
              onCheckout: (orders) {},
            ),
      },
    );
  }
}
