import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:progros/logic/product/product_cubit.dart';
import 'package:progros/logic/search/search_cubit.dart';
import 'package:progros/logic/search/search_state.dart';
import 'package:progros/presentation/products/horizontal_products.dart';
import 'package:progros/core/constant/app_stringconst.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  final _focus = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<SearchCubit, SearchState>(
          builder: (context, s) {
            final productsState = context.watch<ProductsCubit>().state;
            return ListView(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 48.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 12.w),
                            Icon(
                              Icons.search,
                              size: 22.sp,
                              color: Colors.black54,
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: TextField(
                                controller: _controller,
                                focusNode: _focus,
                                onChanged: context
                                    .read<SearchCubit>()
                                    .onQueryChanged,
                                onSubmitted: context.read<SearchCubit>().search,
                                decoration: const InputDecoration(
                                  hintText: ApplicationStrings.searchLocation,
                                  isCollapsed: true,
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            if (s.query.isNotEmpty)
                              IconButton(
                                icon: Icon(Icons.close, size: 18.sp),
                                onPressed: () {
                                  _controller.clear();
                                  context.read<SearchCubit>().clearQuery();
                                  _focus.requestFocus();
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(12.r),
                      child: Container(
                        height: 48.h,
                        width: 48.w,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.tune,
                          color: Colors.white,
                          size: 22.sp,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                if (s.showRecentAndTrending) ...[
                  if (s.recent.isNotEmpty) ...[
                    const Text(
                      'Recent Search',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: s.recent
                          .map(
                            (t) => Chip(
                              label: Text(t),
                              backgroundColor: const Color(0xFFF0F2F5),
                              onDeleted: () =>
                                  context.read<SearchCubit>().removeRecent(t),
                              deleteIcon: const Icon(Icons.close, size: 16),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                          )
                          .toList(),
                    ),
                    SizedBox(height: 20.h),
                  ],
                  const Text(
                    'Trending Now',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 12.h),
                  SizedBox(
                    height: 260.h,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: productsState.trending.length,
                      separatorBuilder: (_, __) => SizedBox(width: 12.w),
                      itemBuilder: (ctx, i) => SizedBox(
                        width: 180.w,
                        child: ProductCard(
                          product: productsState.trending[i],
                          isFromCat: false,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  const Text(
                    'Best Deals',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 12.h),
                  SizedBox(
                    height: 260.h,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: productsState.bestDeals.length,
                      separatorBuilder: (_, __) => SizedBox(width: 12.w),
                      itemBuilder: (ctx, i) => SizedBox(
                        width: 180.w,
                        child: ProductCard(
                          product: productsState.bestDeals[i],
                          isFromCat: false,
                        ),
                      ),
                    ),
                  ),
                ],

                if (!s.showRecentAndTrending &&
                    s.phase == SearchPhase.results) ...[
                  Text(
                    'Showing Result for "${s.query}"',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      // Calculate crossAxisCount based on screen width
                      final width = constraints.maxWidth;
                      int crossAxisCount = 2;
                      if (width >= 600) {
                        crossAxisCount = 3;
                      }
                      if (width >= 900) {
                        crossAxisCount = 4;
                      }
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: s.results.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: .63,
                        ),
                        itemBuilder: (ctx, i) => ProductCard(
                          product: s.results[i],
                          isFromCat: false,
                        ),
                      );
                    },
                  ),
                ],

                if (s.phase == SearchPhase.loading)
                  const Padding(
                    padding: EdgeInsets.only(top: 24),
                    child: Center(child: CircularProgressIndicator()),
                  ),

                if (s.phase == SearchPhase.error)
                  Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: Text(s.error ?? 'Something went wrong'),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
