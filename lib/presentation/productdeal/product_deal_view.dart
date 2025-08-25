import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:progros/models/product_model.dart';
import 'package:progros/presentation/products/horizontal_products.dart';

class BestDealScreen extends StatelessWidget {
  const BestDealScreen({
    required this.title, required this.products, super.key,
  });

  final String title;
  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          title,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, c) {
          final double width = c.maxWidth;
          // Responsive columns
          int crossAxisCount = 2;
          if (width >= 700) {
            crossAxisCount = 4;
          } else if (width >= 500) {
            crossAxisCount = 3;
          }


          final double itemWidth =
              (width - (16.w * 2) - (12.w * (crossAxisCount - 1))) /
              crossAxisCount;
          final double itemHeight = 280.h; // tune with your card
          final double aspectRatio = itemWidth / itemHeight;

          return GridView.builder(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
            itemCount: products.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: aspectRatio,
            ),
            itemBuilder: (context, index) {
              final p = products[index];
              return ProductCard(
                product: p,
                isFromCat: true, // grid uses compact layout
              );
            },
          );
        },
      ),
    );
  }
}
