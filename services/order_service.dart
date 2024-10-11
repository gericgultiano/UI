import 'package:collection/collection.dart';
import '../models/order.dart';
import '../models/product.dart';

class OrderService {
  final List<Order> _orders = [];

  // Generates a unique order ID
  String _generateId() => DateTime.now().millisecondsSinceEpoch.toString();

  // Creates a new order and adds it to the list
  void createOrder(Map<Product, int> productsWithQuantities) {
    if (productsWithQuantities.isEmpty) {
      throw ArgumentError('Order must contain at least one product.');
    }
    final order = Order(_generateId(), productsWithQuantities);
    _orders.add(order);
  }

  // Updates an existing order by ID
  void updateOrder(String id, Map<Product, int> productsWithQuantities) {
    if (productsWithQuantities.isEmpty) {
      throw ArgumentError('Order must contain at least one product.');
    }
    final orderIndex = _orders.indexWhere((order) => order.id == id);
    if (orderIndex != -1) {
      _orders[orderIndex] = Order(id, productsWithQuantities);
    } else {
      throw ArgumentError('Order with ID $id not found.');
    }
  }

  // Retrieves an unmodifiable list of orders
  List<Order> getOrders() => List.unmodifiable(_orders);

  // Retrieves a specific order by ID
  Order? getOrderById(String id) {
    return _orders.firstWhereOrNull((order) => order.id == id);
  }
}
