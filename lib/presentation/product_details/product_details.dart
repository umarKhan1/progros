import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:progros/core/extension/sizedbox_ext.dart';

import 'package:progros/logic/product/product_cubit.dart';
import 'package:progros/models/product_details_model.dart';
import 'package:progros/presentation/product_details/widget/discount_price.dart';
import 'package:progros/presentation/product_details/widget/product_crousal.dart';
import 'package:progros/presentation/product_details/widget/quantity_added.dart';
import 'package:progros/presentation/product_details/widget/readmore.dart';
import 'package:progros/presentation/product_details/widget/review_section.dart';
import 'package:progros/presentation/products/horizontal_products.dart';

class ProductDetailsPage extends StatelessWidget {
  const ProductDetailsPage({required this.product, super.key});
  final ProductDetailModel product;

  @override
  Widget build(BuildContext context) {
    // Prepare sample reviews data for the widget
    final sampleReviews = [
      {
        'avatarUrl': 'https://randomuser.me/api/portraits/men/1.jpg',
        'name': 'Johnson Smith',
        'date': 'April 10, 2023',
        'text':
            "Recently I have purchased this perfume and it's fragrance is very nice, I loved it",
        'images': [product.images[0]],
      },
    ];

    final productsCubit = context.read<ProductsCubit>();
    final similarProducts = productsCubit.state.all.take(4).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Item Details',
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16.w),
              children: [
                ProductImageCarousel(images: product.images),
                16.hsb,
                // Replace TitleRatingRow and the following Row with a custom layout matching the screenshot
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    8.hsb,
                    Row(
                      children: [
                        ...List.generate(
                          4,
                          (i) => const Icon(
                            Icons.star,
                            color: Colors.green,
                            size: 18,
                          ),
                        ),
                        const Icon(
                          Icons.star_border,
                          color: Colors.green,
                          size: 18,
                        ),
                        8.wsb,
                        Text(
                          '4.0',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        4.wsb,
                        Text(
                          '(146 Reviews)',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
                8.hsb,
                PriceDiscountRow(
                  price: product.price,
                  compareAt: product.compareAt,
                  discount: product.discount,
                ),
                Divider(height: 10.h, thickness: 0.6, color: Colors.grey),
                DescriptionReadMore(description: product.description),
                Divider(height: 32.h),
                ReviewsSection(
                  rating: product.rating,
                  reviewCount: 120,
                  reviews: sampleReviews,
                ),
                16.hsb,
                Text(
                  'Similar Products',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                16.hsb,
                SizedBox(
                  height: 300.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: similarProducts.length,
                    separatorBuilder: (_, __) => 12.wsb,
                    itemBuilder: (_, i) => SizedBox(
                      width: 200.w,
                      child: ProductCard(
                        product: similarProducts[i],
                        isFromCat: false,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          QuantityAddToCartBar(product: product),
        ],
      ),
    );
  }
}
