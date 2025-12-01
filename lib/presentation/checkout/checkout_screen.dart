import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:progros/core/constant/app_image_const.dart';
import 'package:progros/core/extension/sizedbox_ext.dart';
import 'package:progros/logic/basket/basket_cubit.dart';
import 'package:progros/logic/basket/basket_state.dart';
import 'package:progros/logic/product/product_cubit.dart';
import 'package:progros/logic/product/product_state.dart';
import 'package:progros/presentation/checkout/widget/checkout_item.dart';
import 'package:progros/presentation/checkout/widget/checkout_price.dart';
import 'package:progros/presentation/checkout/widget/recomended_cards.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final ScrollController _recommendedController = ScrollController();

  @override
  void dispose() {
    _recommendedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
 
      body: SafeArea(
        child: BlocBuilder<BasketCubit, BasketState>(
          builder: (context, basketState) {
            final basket = basketState.items;
            if (basket.isEmpty) {
              return SizedBox.expand(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_basket_outlined, size: 64, color: Colors.grey),
                      16.hsb,
                      Text(
                        'Nothing in basket',
                        style: TextStyle(fontSize: 18.sp, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            }
            return ListView(
              padding: EdgeInsets.all(16.w),
              children: [
                Column(
                  children: [
                    ...basket.map(
                      (item) => Dismissible(
                        key: ValueKey(item.product.id),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) =>
                            context.read<BasketCubit>().remove(item.product),
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        child: CheckoutItemTile(item: item),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Text(
                  'Before you Checkout',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                ),
                SizedBox(height: 8.h),
                SizedBox(
                  height: 280.h,
                  child: BlocBuilder<ProductsCubit, ProductsState>(
                    builder: (context, productState) {
                      final recommended = productState.all.take(4).toList();
                      return RecommendedProductsList(
                        recommended: recommended,
                        controller: _recommendedController,
                      );
                    },
                  ),
                ),
                SizedBox(height: 16.h),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Image.asset(ApplicationImagesStrings.promo,color: Theme.of(context).primaryColor, height: 30, width: 30, fit: BoxFit.cover,),
                  title: const Text('APPLY COUPON'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black, weight: 2.1,),
                  onTap: () {
           
                  },
                ),
                const Divider(
                  thickness: 0.4,
                  color: Colors.grey,
                ),
         
                const CheckoutSummary(),
              ],
            );
          },
        ),
      ),
    );
  }
}





