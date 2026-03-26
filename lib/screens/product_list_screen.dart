import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/product.dart';
import 'cart_screen.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Product>('cartBox');

    final products = [
      Product(name: "Nike Air Max", price: 120.00, quantity: 1),
      Product(name: "Sport T-Shirt", price: 40.00, quantity: 1),
      Product(name: "Urban Cap", price: 25.00, quantity: 1),
      Product(name: "Running Shorts", price: 35.00, quantity: 1),
      Product(name: "Gym Bag", price: 55.00, quantity: 1),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Store",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          ValueListenableBuilder(
            valueListenable: box.listenable(),
            builder: (context, Box<Product> box, _) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart_outlined,
                        color: Colors.black),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CartScreen(),
                        ),
                      );
                    },
                  ),
                  if (box.isNotEmpty)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Color(0xFF4A6CF7),
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${box.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F7FB),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.shopping_bag_outlined,
                      color: Color(0xFF4A6CF7), size: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "\$${product.price.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF4A6CF7),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A6CF7),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  onPressed: () {
                    box.add(product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("${product.name} añadido al carrito"),
                        duration: const Duration(seconds: 1),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: const Color(0xFF4A6CF7),
                      ),
                    );
                  },
                  child: const Text("Add"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
