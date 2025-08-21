import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:progros/core/constant/app_image_const.dart';
import 'package:progros/core/constant/app_stringconst.dart';
import 'package:progros/core/extension/app_routes_ext.dart';
import 'package:progros/core/extension/sizedbox_ext.dart';
import 'package:progros/presentation/auth/login/login_view.dart';
import 'package:progros/presentation/widget/already_haveac.dart';
import 'package:progros/widget/app_button.dart';
import 'package:progros/widget/socialbutton.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: .55.sh,
            width: double.infinity,
            child: Image.asset(
              ApplicationImagesStrings.welcome, // replace with your image path
              fit: BoxFit.cover,
            ),
          ),
          47.hsb,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ApplicationStrings.welcome,
                  style: TextStyle(
                    fontSize: 29.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                10.hsb,
                Text(
                  ApplicationStrings.welcomedescp,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                20.hsb,
                SocialButton(
                  title: ApplicationStrings.signingoogle,
                  withImage: true,
                  onPressed: () {},
                  imagepath: ApplicationImagesStrings.google,
                ),
                10.hsb,

                ApplicationButton(
                  title: ApplicationStrings.createAccount,
                  withImage: true,
                  imagepath: ApplicationImagesStrings.wcImage,
                  onPressed: () {},
                ),
                20.hsb,
                AlreadyAndDontHaveAccountText(
                  isFromLogin: true,
                  onLoginTap: () {
                    context.push(const LoginScreen());
                  },
                ),
              ],
            ),
          ),
          // Bottom Container
        ],
      ),
    );
  }
}
