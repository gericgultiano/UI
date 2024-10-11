import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final Function(Product, int) addToCart;

  ProductCard({required this.product, required this.addToCart});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(product.name,
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text('₱${product.price.toStringAsFixed(2)}'),
          ),
          ElevatedButton(
            onPressed: () {
              // Display a dialog to select quantity
              showDialog(
                context: context,
                builder: (context) {
                  return QuantityDialog(
                    onQuantitySelected: (quantity) {
                      addToCart(product, quantity);
                      Navigator.of(context)
                          .pop(); // Close dialog after adding to cart

                      // Show Snackbar
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${product.name} added to cart'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  );
                },
              );
            },
            child: Text('Add to Cart'),
          ),
        ],
      ),
    );
  }
}

class QuantityDialog extends StatefulWidget {
  final Function(int) onQuantitySelected;

  QuantityDialog({required this.onQuantitySelected});

  @override
  _QuantityDialogState createState() => _QuantityDialogState();
}

class _QuantityDialogState extends State<QuantityDialog> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Quantity'),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.remove),
            onPressed: () {
              if (_quantity > 1) setState(() => _quantity--);
            },
          ),
          Text('$_quantity'),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => setState(() => _quantity++),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            widget.onQuantitySelected(_quantity);
            Navigator.of(context).pop();
          },
          child: Text('Add to Cart'),
        ),
      ],
    );
  }
}
