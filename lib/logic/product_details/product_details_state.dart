import 'package:progros/models/product_details_model.dart';

abstract class ProductDetailState {}

class ProductDetailLoading extends ProductDetailState {}

class ProductDetailLoaded extends ProductDetailState {
  ProductDetailLoaded({required this.product, required this.similarProducts});
  final ProductDetailModel product;
  final List<ProductDetailModel> similarProducts;
}

class ProductDetailError extends ProductDetailState {
  ProductDetailError(this.message);
  final String message;
}
