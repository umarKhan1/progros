import 'package:progros/models/product_model.dart';

class BasketItem {
  BasketItem({required this.product, required this.quantity});
  final Product product;
  final int quantity;

  BasketItem copyWith({int? quantity}) =>
      BasketItem(product: product, quantity: quantity ?? this.quantity);
}
