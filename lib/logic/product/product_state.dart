import 'package:equatable/equatable.dart';
import 'package:progros/models/product_model.dart';


class ProductsState extends Equatable {

  const ProductsState({this.all = const []});
  final List<Product> all;

  List<Product> get trending => all.where((p) => p.isTrending).toList();
  List<Product> get bestDeals => all.where((p) => p.isBestDeal).toList();

  ProductsState copyWith({List<Product>? all}) => 
  ProductsState(all: all ?? this.all);

  @override
  List<Object?> get props => [all];
}
