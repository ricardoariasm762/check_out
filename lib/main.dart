import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/product.dart';
import 'screens/cart_screen.dart';
import 'screens/product_list_screen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Hive
  await Hive.initFlutter();

  // Registrar el Adapter del modelo Product
  Hive.registerAdapter(ProductAdapter());

  // Abrir la caja donde se guardarán los productos
  await Hive.openBox<Product>('cartBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ProductListScreen(),
    );
  }
}