import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:progros/core/constant/app_stringconst.dart';
import 'package:progros/presentation/dashboard/widget/banner_shimmer.dart';

class AppBanner extends StatelessWidget {
  const AppBanner({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final bannerHeight = (height * 0.23).clamp(140.0, 260.0);
    final imageWidth = (width * 0.45).clamp(120.0, 260.0);
    final imageHeight = (bannerHeight * 0.85).clamp(90.0, 220.0);
   
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          height: bannerHeight,
          width: double.infinity,
          color: const Color.fromARGB(255, 213, 239, 223),
          child: Stack(
            children: [
              Positioned(
                right: 0,
                bottom: 0,
                top: 0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: CachedNetworkImage(
                    imageUrl: 'https://www.sharpshopper.net/Images/2016-Product-Slideshow.gif',
                    height: imageHeight,
                    width: imageWidth,
                    fit: BoxFit.fill,
                    placeholder: (context, url) => const BannerShimmer(),
                    errorWidget: (context, url, error) => const Icon(Icons.broken_image),
                  ),
                ),
              ),
              // Left text and button
              Padding(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ApplicationStrings.worldFoodFestival,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF1F2937),
                        height: 1.3,
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: onTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF34C759),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 12.h),
                      ),
                      child: Text(
                        ApplicationStrings.shopNow,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
