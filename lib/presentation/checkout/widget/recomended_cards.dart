import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:progros/logic/basket/basket_cubit.dart';
import 'package:progros/models/basket_model.dart';
import 'package:progros/models/product_model.dart';

class RecommendedProductsList extends StatelessWidget {
  const RecommendedProductsList({
    required this.recommended,
    required this.controller,
    super.key,
  });
  final List<Product> recommended;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: controller,
      scrollDirection: Axis.horizontal,
      itemCount: recommended.length,
      separatorBuilder: (_, __) => SizedBox(width: 12.w),
      itemBuilder: (_, i) => RecommendedProductCard(product: recommended[i]),
    );
  }
}

class RecommendedProductCard extends StatelessWidget {
  const RecommendedProductCard({required this.product, super.key});
  final Product product;

  @override
  Widget build(BuildContext context) {
    final double cardWidth = 0.42.sw;
    final double imageHeight = 0.18.sh;
    final basketCubit = context.watch<BasketCubit>();
    // Find basket item for this product, or null if not found
    BasketItem? basketItem;
    for (final item in basketCubit.state.items) {
      if (item.product.id == product.id) {
        basketItem = item;
        break;
      }
    }
    final int quantity = basketItem?.quantity ?? 0;
    return SizedBox(
      height: 260.h,
      child: Container(
        width: cardWidth,
        margin: EdgeInsets.only(right: 12.w),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
              child: Image.network(
                product.image,
                height: imageHeight,
                width: cardWidth,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: product.title.length > 18 ? 11.sp : 13.sp,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    product.size,
                    style: TextStyle(color: Colors.grey, fontSize: 11.sp),
                  ),
                  Row(
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13.sp,
                        ),
                      ),
                      if (product.compareAt != null)
                        Padding(
                          padding: EdgeInsets.only(left: 4.w),
                          child: Text(
                            '\$${product.compareAt!.toStringAsFixed(0)}',
                            style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                              fontSize: 11.sp,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(9.w),
              child: SizedBox(
                width: double.infinity,
                child: quantity == 0
                    ? ElevatedButton(
                        onPressed: () {
                          context.read<BasketCubit>().add(product);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          minimumSize: Size(0, 32.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          padding: EdgeInsets.zero,
                        ),
                        child: Text(
                          'Add',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : Container(
                        height: 30.h,
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(color: Colors.green),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () => context
                                  .read<BasketCubit>()
                                  .decrement(product),
                              child: Icon(
                                Icons.remove,
                                color: Colors.green,
                                size: 20.r,
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Text(
                              '$quantity',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15.sp,
                              ),
                            ),
                            SizedBox(width: 16.w),
                            GestureDetector(
                              onTap: () => context
                                  .read<BasketCubit>()
                                  .increment(product),
                              child: Icon(
                                Icons.add,
                                color: Colors.green,
                                size: 20.r,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
