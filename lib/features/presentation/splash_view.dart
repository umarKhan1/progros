
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progros/core/constant/app_image_const.dart';
import 'package:progros/core/extension/theme_ext.dart';
import 'package:progros/logic/splash_screen_cubit.dart';


class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
        listener: (context, state) {
          if (state == SplashState.completed) {
          //  context.pushReplacement( const OnboardingView());
          }
        },
        child: Scaffold(
          backgroundColor: context.primaryColor,
          body:     Center(
                child: Image.asset(
                  ApplicationImagesStrings.logo,
            
                ),
              ),  ),
      );
  }
}

class ApplicationImageConst {
}
