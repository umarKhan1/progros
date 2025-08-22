import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progros/logic/basket/basket_state.dart';
import 'package:progros/models/basket_model.dart';
import 'package:progros/models/product_model.dart';

class BasketCubit extends Cubit<BasketState> {
  BasketCubit() : super(const BasketState());

  void add(Product product) {
    final existing = state.items
        .where((e) => e.product.id == product.id)
        .toList();
    if (existing.isEmpty) {
      emit(
        BasketState(
          items: [
            ...state.items,
            BasketItem(product: product, quantity: 1),
          ],
        ),
      );
    }
  }

  void increment(Product product) {
    final items = state.items.map((e) {
      if (e.product.id == product.id) {
        return e.copyWith(quantity: e.quantity + 1);
      }
      return e;
    }).toList();
    emit(BasketState(items: items));
  }

  void decrement(Product product) {
    final items = state.items
        .map((e) {
          if (e.product.id == product.id) {
            if (e.quantity > 1) {
              return e.copyWith(quantity: e.quantity - 1);
            }
            return null;
          }
          return e;
        })
        .whereType<BasketItem>()
        .toList();
    emit(BasketState(items: items));
  }

  void remove(Product product) {
    emit(
      BasketState(
        items: state.items.where((e) => e.product.id != product.id).toList(),
      ),
    );
  }

  int getQuantity(Product product) {
    final found = state.items.where((e) => e.product.id == product.id);
    return found.isNotEmpty ? found.first.quantity : 0;
  }
}
