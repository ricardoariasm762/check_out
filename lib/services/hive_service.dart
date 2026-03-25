import 'package:hive/hive.dart';
import '../models/product.dart';

class HiveService {

  static final box = Hive.box<Product>('cartBox');

  static void addProduct(Product product) {
    box.add(product);
  }

  static void removeProduct(int index) {
    box.deleteAt(index);
  }

  static List<Product> getProducts() {
    return box.values.toList();
  }

  static double getTotal() {
    return box.values.fold(0, (sum, item) => sum + item.total);
  }
}