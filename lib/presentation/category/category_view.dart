import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:progros/core/constant/app_stringconst.dart';
import 'package:progros/core/extension/app_routes_ext.dart';
import 'package:progros/models/cat_subcat_model.dart';
import 'package:progros/presentation/category/category_detail.dart';
import 'package:progros/presentation/category/widget/category_card.dart';

class HomeShopSection extends StatelessWidget {
  const HomeShopSection({super.key});

  @override
  Widget build(BuildContext context) {
    // use the global `categories` from cat_subcat_model.dart
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Shop By Category',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
              ),
              TextButton(
                onPressed: () => context.push(
                  const AllCategoriesPage(categories: categories),
                ),
                child: const Text(ApplicationStrings.seeAll),
              ),
            ],
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: .8,
          ),
          itemBuilder: (context, index) {
            final c = categories[index];
            return CategoryCard(
              category: c,
              onTap: () => context.push(CategoryDetailsPage(category: c)),
            );
          },
        ),
      ],
    );
  }
}

class AllCategoriesPage extends StatelessWidget {

  const AllCategoriesPage({required this.categories, super.key});
  final List<Category> categories;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(ApplicationStrings.allCategories)),
      body: GridView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: categories.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: .8,
        ),
        itemBuilder: (context, index) {
          final c = categories[index];
          return CategoryCard(
            category: c,
            onTap: () => context.push(CategoryDetailsPage(category: c)),
          );
        },
      ),
    );
  }
}
