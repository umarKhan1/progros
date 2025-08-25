// category_detail.dart (exact layout, flat left, right grid, fallback if empty)
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:progros/core/constant/app_stringconst.dart';
import 'package:progros/logic/category/category_cubit.dart';
import 'package:progros/logic/category/category_state.dart';
import 'package:progros/logic/product/product_cubit.dart';
import 'package:progros/logic/product/product_state.dart';
import 'package:progros/models/cat_subcat_model.dart';
import 'package:progros/presentation/category/widget/sub_cat_list.dart';
import 'package:progros/presentation/products/horizontal_products.dart'; // your ProductCard

class CategoryDetailsPage extends StatelessWidget {
  const CategoryDetailsPage({super.key, required this.category});
  final Category category;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CategoryCubit>(
      create: (_) =>
          CategoryCubit(categories: categories, initialCategoryId: category.id),
      child: _CategoryDetailsContent(category: category),
    );
  }
}

class _CategoryDetailsContent extends StatelessWidget {
  const _CategoryDetailsContent({required this.category});
  final Category category;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategorySelectionState>(
      builder: (context, catState) {
        final subs = catState.currentSubcategories;

        return Scaffold(
          backgroundColor: const Color(0xFFF7F8FA),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            centerTitle: true,
            title: Text(
              category.name,
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
            ),
            actions: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
            ],
          ),
          body: Row(
            children: [
              // left rail, flat
              SizedBox(
                width: 104.w,
                child: SubcategoryRail(
                  subs: subs,
                  selectedId: catState.subCategoryId,
                  onChanged: (id) =>
                      context.read<CategoryCubit>().selectSubCategory(id),
                ),
              ),
              // right grid
              Expanded(
                child: BlocBuilder<ProductsCubit, ProductsState>(
                  builder: (context, productsState) {
                    final productsCubit = context.read<ProductsCubit>();
                    var items = productsCubit.bySubCategory(
                      catState.subCategoryId,
                    );
                    if (items.isEmpty) {
                      items = productsCubit.byCategory(catState.categoryId);
                    }

                    if (items.isEmpty) {
                      return const Center(
                        child: Text(ApplicationStrings.errorImage),
                      );
                    }

                    return GridView.builder(
                      padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: .68,
                          ),
                      itemCount: items.length,
                      itemBuilder: (_, i) =>
                          ProductCard(product: items[i], isFromCat: true),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
