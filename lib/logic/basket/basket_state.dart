import 'package:progros/models/basket_model.dart';
import 'package:progros/models/product_model.dart';

class BasketState {
  const BasketState({this.items = const []});
  final List<BasketItem> items;

  BasketItem? getItem(Product product) {
    final found = items.where((e) => e.product.id == product.id);
    return found.isNotEmpty ? found.first : null;
  }
}
