import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:progros/logic/basket/basket_cubit.dart';
import 'package:progros/logic/basket/basket_state.dart';
import 'package:progros/models/product_model.dart';
import 'package:progros/presentation/search/widget/shimmer_loader.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    required this.product,
    required this.isFromCat,
    super.key,
  });

  final bool isFromCat;
  final Product product;

  @override
  Widget build(BuildContext context) {
    final double pad = (isFromCat ? 10 : 12).w;
    final double cardRadius = 16.r;
    final double imageRadius = 12.r;

    final double titleSize = (isFromCat ? 12 : 14).sp;
    final double metaSize = (isFromCat ? 10 : 12).sp;
    final double priceSize = (isFromCat ? 12 : 14).sp;
    final double qtyTextSize = (isFromCat ? 14 : 16).sp;
    final double iconSize = (isFromCat ? 20 : 24).r;

    final Size addBtnSize =
        Size((isFromCat ? 56 : 64).w, (isFromCat ? 32 : 36).h);

    return BlocBuilder<BasketCubit, BasketState>(
      builder: (context, state) {
        final cubit = context.read<BasketCubit>();
        final qty = cubit.getQuantity(product);

        return LayoutBuilder(
          builder: (context, box) {
            final bool compact = isFromCat && box.maxHeight < 220.h;

            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(cardRadius),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x11000000),
                    blurRadius: 16,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              padding: EdgeInsets.all(pad),
              child: Column(
               
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image
                  Expanded(
                    flex: compact ? 5 : (isFromCat ? 6 : 7),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(imageRadius),
                      child: CachedNetworkImage(
                        imageUrl: product.image,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => SizedBox.expand(
                          child: SearchShimmerLoader(
                            width: double.infinity,
                            height: double.infinity,
                            borderRadius:
                                BorderRadius.circular(imageRadius),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey.shade200,
                          alignment: Alignment.center,
                          child: Icon(Icons.broken_image,
                              color: Colors.grey, size: 32.r),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: compact ? 6.h : 8.h),

                  // Title
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: compact ? (titleSize - 1.sp) : titleSize,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                  ),

                  SizedBox(height: compact ? 2.h : (isFromCat ? 4.h : 6.h)),

                  // Size / meta
                  if (product.size.isNotEmpty)
                    Text(
                      product.size,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: compact ? (metaSize - 1.sp) : metaSize,
                        height: 1.1,
                      ),
                    ),

                  SizedBox(height: compact ? 6.h : 8.h),

                  // Price + actions
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    transitionBuilder: (child, anim) =>
                        FadeTransition(opacity: anim, child: child),
                    child: Row(
                      key: ValueKey(qty == 0 ? 'add' : 'qty'),
                   
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Text(
                                '\$${product.price.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: compact
                                      ? (priceSize - 1.sp)
                                      : priceSize,
                                ),
                              ),
                              SizedBox(width: 6.w),
                              if (product.compareAt != null)
                                Flexible(
                                  child: Text(
                                    '\$${product.compareAt!.toStringAsFixed(0)}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.black38,
                                      fontSize: compact
                                          ? (metaSize - 1.sp)
                                          : metaSize,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        if (qty == 0)
                          SizedBox(
                            width: addBtnSize.width,
                            height: addBtnSize.height,
                            child: ElevatedButton(
                              onPressed: () => cubit.add(product),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).primaryColor,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  'Add',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: compact
                                        ? (metaSize - 1.sp)
                                        : metaSize,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          )
                        else
                          Row(
                            key: const ValueKey('qtyRow'),
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _qtyIconBtn(
                                context: context,
                                icon: Icons.remove_circle_outline,
                                size: compact
                                    ? (iconSize - 2.r)
                                    : iconSize,
                                onTap: () => cubit.decrement(product),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 4.w),
                                child: Text(
                                  '$qty',
                                  style: TextStyle(
                                    fontSize: compact
                                        ? (qtyTextSize - 1.sp)
                                        : qtyTextSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              _qtyIconBtn(
                                context: context,
                                icon: Icons.add_circle_outline,
                                size: compact
                                    ? (iconSize - 2.r)
                                    : iconSize,
                                onTap: () => cubit.increment(product),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

Widget _qtyIconBtn({
  required BuildContext context,
  required IconData icon,
  required double size,
  required VoidCallback onTap,
}) {
  return IconButton(
    icon: Icon(icon, color: Theme.of(context).primaryColor, size: size),
    onPressed: onTap,
    padding: EdgeInsets.zero,
    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
    visualDensity: const VisualDensity(horizontal: -3, vertical: -3),
    splashRadius: 20,
  );
}
