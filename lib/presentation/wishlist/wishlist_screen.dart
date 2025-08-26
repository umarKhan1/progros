import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:progros/features/const.dart';
import 'package:progros/logic/wishlist/wishlist_cubit.dart';
import 'package:progros/models/product_model.dart';
import 'package:progros/presentation/products/horizontal_products.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: const Text('Wishlist')),
      body: BlocBuilder<WishlistCubit, List<Product>>(
        builder: (context, wishlist) {
          if (wishlist.isEmpty) {
            return SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: 48,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      AppConst.noWishlistFound,
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return SafeArea(
            child: GridView.builder(
              padding: EdgeInsets.all(16.w),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12.w,
                mainAxisSpacing: 12.h,
                childAspectRatio: .68,
              ),
              itemCount: wishlist.length,
              itemBuilder: (_, i) =>
                  ProductCard(product: wishlist[i], isFromCat: false),
            ),
          );
        },
      ),
    );
  }
}
