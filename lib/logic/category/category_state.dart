import 'package:equatable/equatable.dart';
import 'package:progros/models/cat_subcat_model.dart';

class CategorySelectionState extends Equatable {
  const CategorySelectionState({
    required this.categories,
    required this.categoryId,
    required this.subCategoryId,
  });
  final List<Category> categories;
  final String categoryId;
  final String subCategoryId;

  Category get currentCategory => categories.firstWhere(
    (c) => c.id == categoryId,
    orElse: () => categories.first,
  );

  List<SubCategory> get currentSubcategories => currentCategory.subs;

  CategorySelectionState copyWith({
    List<Category>? categories,
    String? categoryId,
    String? subCategoryId,
  }) {
    return CategorySelectionState(
      categories: categories ?? this.categories,
      categoryId: categoryId ?? this.categoryId,
      subCategoryId: subCategoryId ?? this.subCategoryId,
    );
  }

  @override
  List<Object?> get props => [categories, categoryId, subCategoryId];
}
