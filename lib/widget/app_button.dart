import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:progros/core/extension/sizedbox_ext.dart';

class ApplicationButton extends StatelessWidget {
  const ApplicationButton({
    required this.title,
    required this.onPressed,
    this.withImage = false,
    this.imagepath = '',
    super.key,
  });
  final String title;
  final VoidCallback onPressed;
  final bool withImage;
  final String imagepath;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style:
          ElevatedButton.styleFrom(
            elevation: 6,
            minimumSize: Size(double.infinity, 52.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            padding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            shadowColor: Colors.black12,
          ).copyWith(
            backgroundColor: WidgetStateProperty.all(Colors.transparent),
            surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
          ),
      child: Ink(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF91E561), Color(0xFF2FB45A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Container(
          alignment: Alignment.center,
          padding: withImage
              ? EdgeInsets.symmetric(horizontal: 16.w)
              : EdgeInsets.zero,
          height: 52.h,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: withImage
                ? MainAxisAlignment.start
                : MainAxisAlignment.center,
            children: [
              if (withImage)
                Padding(
                  padding: EdgeInsets.only(left: 16.w),
                  child: Image.asset(imagepath, width: 24.w, height: 24.h),
                ),
              if (withImage) 60.wsb,
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
