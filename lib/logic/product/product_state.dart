import 'package:equatable/equatable.dart';
import 'package:progros/models/cat_subcat_model.dart';
import 'package:progros/models/product_model.dart';

class ProductsState extends Equatable {
  const ProductsState({
    this.all = const [],
    this.categories = const [],
    this.selectedCategory,
  });
  final List<Product> all;
  final List<Category> categories;
  final String? selectedCategory;
  List<Product> get trending =>
      all.where((p) => p.isTrending).toList();
  List<Product> get bestDeals =>
      all.where((p) => p.isBestDeal).toList();
  List<Product> get filteredByCategory {
    if (selectedCategory == null) return all;
    return all.where((p) => p.categoryId == selectedCategory).toList();
  }
  ProductsState copyWith({
    List<Product>? all,
    List<Category>? categories,
    String? selectedCategory,
  }) {
    return ProductsState(
      all: all ?? this.all,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }

  @override
  List<Object?> get props => [all, categories, selectedCategory];
}
