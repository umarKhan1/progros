import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension SizedBoxHeightExtension on num {
  SizedBox get hsb => SizedBox(height: h);
  SizedBox get wsb => SizedBox(width: w);
}
