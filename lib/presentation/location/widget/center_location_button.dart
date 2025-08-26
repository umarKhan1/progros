import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:progros/logic/location/location_cubit.dart';

class CenterLocationButton extends StatelessWidget {
  const CenterLocationButton({super.key});
 
  @override
  Widget build(BuildContext context) {
       final height = 1.sh;
   final bottomHeight = (height * 0.28).clamp(220.h, 320.h);
    return    Positioned(
                  right: 16.w,
                  bottom: bottomHeight + 16.h,
                  child: SizedBox(
                    width: 56.w,
                    height: 56.w,
                    child: FloatingActionButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28.r),
                      ),
                      backgroundColor: const Color(0xFF2ECC71),
                      onPressed: context
                          .read<LocationCubit>()
                          .centerOnMyLocation,
                      child: Icon(
                        Icons.my_location,
                        color: Colors.white,
                        size: 24.sp,
                      ),
                    ),
                  ),
                );
  }
}
