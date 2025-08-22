import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:progros/core/extension/sizedbox_ext.dart';
import 'package:progros/logic/basket/basket_cubit.dart';
import 'package:progros/logic/basket/basket_state.dart';
import 'package:progros/models/product_model.dart';
import 'package:progros/presentation/search/widget/shimmer_loader.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({required this.product, super.key});
  final Product product;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BasketCubit, BasketState>(
      builder: (context, basketState) {
        final basketCubit = context.read<BasketCubit>();
        final qty = basketCubit.getQuantity(product);
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: const [
              BoxShadow(
                color: Color(0x11000000),
                blurRadius: 16,
                offset: Offset(0, 6),
              ),
            ],
          ),
          padding: EdgeInsets.all(12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1.3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: CachedNetworkImage(
                    imageUrl: product.image,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => SizedBox.expand(
                      child: SearchShimmerLoader(
                        width: double.infinity,
                        height: double.infinity,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey.shade200,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.broken_image,
                        color: Colors.grey,
                        size: 32.r,
                      ),
                    ),
                  ),
                ),
              ),
              10.hsb,
              Text(
                product.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 6.h),
              Text(
                product.size,
                style: TextStyle(color: Colors.black54, fontSize: 12.sp),
              ),
              const Spacer(),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (child, anim) =>
                    FadeTransition(opacity: anim, child: child),
                child:  Row(
                        key: const ValueKey('add'),
                        children: [
                          Text(
                            '\$${product.price.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14.sp,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          if (product.compareAt != null)
                            Text(
                              '\$${product.compareAt!.toStringAsFixed(0)}',
                              style: TextStyle(
                                color: Colors.black38,
                                fontSize: 12.sp,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          const Spacer(),
                        if (qty == 0) ElevatedButton(
                            onPressed: () {
                              basketCubit.add(product);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              minimumSize: Size(64.w, 36.h),
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            child: Text(
                              'Add',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                              ),
                            ),
                          ) else 
                        Row(
                        key: const ValueKey('qty'),
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove_circle_outline,color: Theme.of(context).primaryColor, size: 24.r),
                            onPressed: () {
                              basketCubit.decrement(product);
                            },
                          ),
                          Text(
                            '$qty',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.add_circle_outline,
                            color: Theme.of(context).primaryColor,
                             size: 24.r),
                            onPressed: () {
                              basketCubit.increment(product);
                            },
                          ),
                         
                            ],
                      ),
          
                        ],
                      )
                       ),
            ],
          ),
        );
      },
    );
  }
}
