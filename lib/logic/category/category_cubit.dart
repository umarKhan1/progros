import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progros/logic/category/category_state.dart';
import 'package:progros/models/cat_subcat_model.dart';

class CategoryCubit extends Cubit<CategorySelectionState> {
  CategoryCubit({
    required List<Category> categories,
    required String initialCategoryId,
  }) : super(
          CategorySelectionState(
            categories: categories,
            categoryId: initialCategoryId,
            subCategoryId: _firstSub(categories, initialCategoryId),
          ),
        );

  static String _firstSub(List<Category> categories, String catId) {
    final cat = categories.firstWhere(
      (c) => c.id == catId,
      orElse: () => categories.first,
    );
    return cat.subs.isNotEmpty ? cat.subs.first.id : '';
  }

  void selectCategory(String id) {
    emit(
      state.copyWith(
        categoryId: id,
        subCategoryId: _firstSub(state.categories, id),
      ),
    );
  }

  void selectSubCategory(String id) {
    emit(state.copyWith(subCategoryId: id));
  }
}
