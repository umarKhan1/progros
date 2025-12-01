import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:progros/core/extension/app_routes_ext.dart';
import 'package:progros/core/extension/sizedbox_ext.dart';
import 'package:progros/logic/basket/basket_cubit.dart';
import 'package:progros/logic/location/location_cubit.dart';
import 'package:progros/logic/location/location_state.dart';
import 'package:progros/presentation/location/location.dart';
import 'package:progros/presentation/checkout/widget/order_placed_dialog.dart';

class CheckoutSummary extends StatelessWidget {
  const CheckoutSummary({super.key});
  

  @override
  Widget build(BuildContext context) {
    final basket = context.watch<BasketCubit>().state.items;
    final itemTotal = basket.fold<double>(
      0,
      (sum, item) => sum + (item.product.price * item.quantity),
    );
    const discountPercent = 2; // 2 percent discount
    final discount = itemTotal * discountPercent / 100;
    final grandTotal = (itemTotal - discount).round();
    const payment = 'Visa 6589';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Item Total', style: TextStyle(fontSize: 15.sp)),
            Text(
              '\$${itemTotal.toStringAsFixed(0)}',
              style: TextStyle(fontSize: 15.sp),
            ),
          ],
        ),
        6.hsb,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Discount', style: TextStyle(fontSize: 15.sp)),
            Text(
              '-\$${discount.toStringAsFixed(0)}',
              style: TextStyle(fontSize: 15.sp),
            ),
          ],
        ),
        6.hsb,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Delivery Free',
              style: TextStyle(color: Colors.green, fontSize: 15.sp),
            ),
            Text(
              'Free',
              style: TextStyle(color: Colors.green, fontSize: 15.sp),
            ),
          ],
        ),
        const Divider(thickness: 0.4, color: Colors.grey),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Grand Total',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
            ),
            Text(
              '\$${grandTotal.toStringAsFixed(0)}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
            ),
          ],
        ),
        18.hsb,
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12.r),
              ),
              padding: EdgeInsets.all(10.r),
              child: Icon(Icons.home, color: Colors.green, size: 24.r),
            ),
            12.wsb,
            Expanded(
              child: BlocBuilder<LocationCubit, LocationState>(
                builder: (context, locationState) {
                  final placeName = locationState.currentPlaceName;
                  final address = locationState.currentAddress;
                  final displayAddress = placeName.isNotEmpty
                      ? placeName
                      : (address.isNotEmpty ? address : 'Select your address');
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('Delivering to ', style: TextStyle(fontSize: 15.sp)),
                          Text(
                            placeName.isNotEmpty ? placeName : 'Home',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.sp,
                            ),
                          ),
                         const  Spacer(),
                          GestureDetector(
                            onTap: () {
                              context.push(const ConfirmLocationPage());
                            },
                            child: Text(
                              'Change',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        displayAddress,
                        style: TextStyle(color: Colors.grey, fontSize: 13.sp),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
        Divider(height: 32.h),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Pay Using',
                      style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey,
                      size: 18.r,
                    ),
                  ],
                ),
                Text(
                  payment,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.sp,
                  ),
                ),
              ],
            ),
            12.wsb,
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (ctx) => OrderPlacedDialog(
                      onViewOrderStatus: () {
                        Navigator.of(ctx).pop();
                        // TODO: Navigate to order status screen
                      },
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12.h,),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '\$$grandTotal',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                        color: Colors.white,
                      ),
                    ),
                    8.wsb,
                    Text(
                      'Place Order',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                        color: Colors.white,
                      ),
                    ),
                    8.wsb,
                    Icon(Icons.arrow_forward, color: Colors.white, size: 20.r),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
