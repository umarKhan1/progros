import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:progros/core/extension/sizedbox_ext.dart';

class SocialButton extends StatelessWidget {

  const SocialButton({
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
      style: ElevatedButton.styleFrom(
        elevation: 0,
        minimumSize: Size(double.infinity, 52.h),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        padding: EdgeInsets.symmetric(horizontal: 30.w),
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          if (withImage)
            Image.asset(
              imagepath,
              width: 24.w,
              height: 24.h,
            ),
          if (withImage) 60.wsb,
          Expanded(
            child: Text(
              title,
              textAlign: withImage ? TextAlign.start : TextAlign.center,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
