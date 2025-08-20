import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:progros/core/constant/app_stringconst.dart';

class AlreadyHaveAccountText extends StatelessWidget {

  const AlreadyHaveAccountText({required this.onLoginTap, super.key});
  final VoidCallback onLoginTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          text: ApplicationStrings.alreadyAccount,
          style: TextStyle(
            fontSize: 15.sp,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
          children: [
            TextSpan(
              text: ApplicationStrings.login,
              recognizer: TapGestureRecognizer()..onTap = onLoginTap,
              style: TextStyle(
                fontSize: 15.sp,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
