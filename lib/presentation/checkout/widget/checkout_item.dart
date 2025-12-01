import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:progros/logic/basket/basket_cubit.dart';
import 'package:progros/models/basket_model.dart';
import 'package:progros/presentation/search/widget/shimmer_loader.dart';

class CheckoutItemTile extends StatelessWidget {
  const CheckoutItemTile({required this.item, super.key});
  final BasketItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 3.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.all(12.w),
            width: 56.w,
            height: 56.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: CachedNetworkImage(
                imageUrl: item.product.image,
                fit: BoxFit.cover,
               
                errorWidget: (context, url, error) => Icon(Icons.broken_image,
                    color: Colors.grey, size: 32.r),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 16.h, bottom: 16.h, right: 8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15.sp,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    item.product.size,
                    style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    '\$${item.product.price.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 50.h, right: 18.w),
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () =>
                      context.read<BasketCubit>().decrement(item.product),
                  child: Icon(Icons.remove, color: Colors.green, size: 18.r),
                ),
                SizedBox(width: 8.w),
                Text(
                  '${item.quantity}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15.sp,
                  ),
                ),
                SizedBox(width: 8.w),
                GestureDetector(
                  onTap: () =>
                      context.read<BasketCubit>().increment(item.product),
                  child: Icon(Icons.add, color: Colors.green, size: 18.r),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
