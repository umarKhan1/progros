import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:progros/core/extension/sizedbox_ext.dart';
import 'package:progros/logic/basket/basket_cubit.dart';
import 'package:progros/models/product_details_model.dart';
import 'package:progros/models/product_model.dart';

class QuantityAddToCartBar extends StatefulWidget {
  const QuantityAddToCartBar({required this.product, super.key});
  final ProductDetailModel product;

  @override
  State<QuantityAddToCartBar> createState() => _QuantityAddToCartBarState();
}

class _QuantityAddToCartBarState extends State<QuantityAddToCartBar> {
  int quantity = 1;
  @override
  Widget build(BuildContext context) {
    final basketCubit = context.read<BasketCubit>();
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12.w),
            ),
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.remove, color: Colors.grey, size: 20.w),
                  onPressed: quantity > 1
                      ? () => setState(() => quantity--)
                      : null,
                ),
                Text(
                  quantity.toString(),
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(fontSize: 18.sp),
                ),
                IconButton(
                  icon: Icon(Icons.add, color: Colors.green, size: 20.w),
                  onPressed: () => setState(() => quantity++),
                ),
              ],
            ),
          ),
          16.wsb,
          Expanded(
            child: GestureDetector(
              onTap: () {
                // Convert ProductDetailModel to Product
                final product = Product(
                  id: widget.product.title,
                  title: widget.product.title,
                  image: widget.product.images.first,
                  size: '',
                  price: widget.product.price,
                  compareAt: widget.product.compareAt,
                  categoryId: '',
                  subCategoryId: '',
                );
                basketCubit.add(product);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Added to basket!')));
              },
              child: Container(
                height: 45.h,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(16.w),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          'Add to Cart',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.sp,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 1.w,
                      height: 32.h,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                    16.wsb,
                    Text(
                      '\$24${widget.product.price}',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.sp,
                      ),
                    ),
                    16.wsb,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
