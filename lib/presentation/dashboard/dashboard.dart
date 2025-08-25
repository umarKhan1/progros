import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:progros/core/constant/app_stringconst.dart';
import 'package:progros/core/extension/app_routes_ext.dart';
import 'package:progros/core/extension/sizedbox_ext.dart';
import 'package:progros/logic/location/location_cubit.dart';
import 'package:progros/logic/location/location_state.dart';
import 'package:progros/logic/product/product_cubit.dart';
import 'package:progros/logic/product/product_state.dart';

import 'package:progros/presentation/category/category_view.dart';
import 'package:progros/presentation/dashboard/widget/banner.dart';
import 'package:progros/presentation/dashboard/widget/header.dart';
import 'package:progros/presentation/dashboard/widget/search_widget.dart';
import 'package:progros/presentation/location/location.dart';
import 'package:progros/presentation/productdeal/product_deal_view.dart';
import 'package:progros/presentation/products/horizontal_products.dart';
import 'package:progros/presentation/search/search_view.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LocationCubit>();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            BlocBuilder<LocationCubit, LocationState>(
              builder: (context, state) {
                final saved = cubit.getSavedAddress();
                final liveAddress = state.currentAddress.isNotEmpty
                    ? state.currentAddress
                    : null;

                return AddressHeader(
                  title: 'Home',
                  address:
                      liveAddress ??
                      saved ??
                      '31, Main Street, Lisboa, Protugal',
                  onTap: () {
                    context.push(const ConfirmLocationPage());
                  },
                  onBagTap: () {
                    // Handle bag tap
                  },
                );
              },
            ),
            SearchEntryRow(
              onOpenSearch: () {
                context.push(const SearchScreen());
              },
              onFilterTap: () {}, // Add filter functionality if needed
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const HomeShopSection(),
                    20.hsb,
                    AppBanner(
                      onTap: () {
                        // Handle banner tap
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              ApplicationStrings.bestDeals,
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              final products = context
                                  .read<ProductsCubit>()
                                  .state
                                  .bestDeals;
                              context.push(
                                BestDealScreen(
                                  products: products,
                                  title: ApplicationStrings.bestDeals,
                                ),
                              );
                            },
                            child: Text(
                              ApplicationStrings.seeAll,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 260.h,
                      child: BlocBuilder<ProductsCubit, ProductsState>(
                        builder: (context, state) {
                          final bestDeals = state.bestDeals;
                          if (bestDeals.isEmpty) {
                            return const Center(
                              child: Text(ApplicationStrings.noBestDealsFound),
                            );
                          }
                          return ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: bestDeals.length,
                            separatorBuilder: (_, __) => SizedBox(width: 12.w),
                            itemBuilder: (ctx, i) => SizedBox(
                              width: 180.w,
                              child: ProductCard(
                                product: bestDeals[i],
                                isFromCat: false,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
