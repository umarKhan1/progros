import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:progros/core/constant/app_stringconst.dart';


class BottomAddressSheet extends StatelessWidget {
  const BottomAddressSheet({
    required this.height,
    required this.address,
    required this.onConfirm,
    required this.saving,
    super.key,
  });

  final double height;
  final String address;
  final bool saving;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        boxShadow: const [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black12,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
           ApplicationStrings.selectlocation,
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 12.h),
          const Divider(height: 0.8, color: Colors.grey, thickness: 0.36),
          SizedBox(height: 8.h),
          Expanded(
            child: SingleChildScrollView(
              child: Text(address, style: TextStyle(fontSize: 16.sp)),
            ),
          ),
          SizedBox(height: 12.h),

          SizedBox(
            width: double.infinity,
            height: 52.h,
            child:
            
            
            
            
             ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2ECC71),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              onPressed: saving ? null : onConfirm,
              child: saving
                  ? SizedBox(
                      height: 20.w,
                      width: 20.w,
                      child: const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      'Confirm Address',
                      style: TextStyle(fontSize: 18.sp, color: Colors.white),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
