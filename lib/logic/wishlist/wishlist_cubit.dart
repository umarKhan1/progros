import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progros/models/product_model.dart';

class WishlistCubit extends Cubit<List<Product>> {
  WishlistCubit() : super([]);

  void toggle(Product product) {
    if (state.any((p) => p.id == product.id)) {
      emit(state.where((p) => p.id != product.id).toList());
    } else {
      emit([...state, product]);
    }
  }

  bool isWishlisted(Product product) => state.any((p) => p.id == product.id);
}
