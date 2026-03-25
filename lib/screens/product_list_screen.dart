import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/product.dart';
import 'cart_screen.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Product>('cartBox');

    final products = [
      Product(name: "Nike Shoes", price: 120, quantity: 1),
      Product(name: "T-Shirt", price: 40, quantity: 1),
      Product(name: "Cap", price: 25, quantity: 1),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text("Products"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CartScreen(),
                ),
              );
            },
          )
        ],
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];

          return Card(
            margin:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: ListTile(
              title: Text(product.name),
              subtitle: Text("\$${product.price}"),
              trailing: ElevatedButton(
                onPressed: () {
                  box.add(product);
                },
                child: const Text("Add"),
              ),
            ),
          );
        },
      ),
    );
  }
}