import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TopLocationAppBar extends StatelessWidget {
  const TopLocationAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56.h,
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios_new, size: 18.sp),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Text(
              'Confirm Delivery Location',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
            ),
          ),
          SizedBox(width: 48.w),
        ],
      ),
    );
  }
}
