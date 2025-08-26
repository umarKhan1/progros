import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progros/logic/product_details/product_details_state.dart';
import 'package:progros/models/product_details_model.dart';

class ProductDetailCubit extends Cubit<ProductDetailState> {
  ProductDetailCubit() : super(ProductDetailLoading());

  Future<void> loadProduct(String productId) async {
    emit(ProductDetailLoading());

    // ignore: inference_failure_on_instance_creation
    await Future.delayed(const Duration(seconds: 1));
    final product = ProductDetailModel.mock();
    emit(
      ProductDetailLoaded(
        product: product,
        similarProducts: ProductDetailModel.mockList(),
      ),
    );
  }
}
