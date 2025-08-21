import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:progros/core/apptheme.dart';

import 'package:progros/core/constant/app_stringconst.dart';
import 'package:progros/logic/auth_validation/login_validation/login_validation_state.dart';
import 'package:progros/logic/auth_validation/signup_validation/signup_validation_cubit.dart';
import 'package:progros/logic/onboarding.dart/on_boarding_cubit.dart';
import 'package:progros/logic/splash_screen_cubit.dart';
import 'package:progros/presentation/splash_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
       designSize: const Size(375, 812),
      splitScreenMode: true,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => SplashCubit()..start()),
          BlocProvider(
            create: (context) => OnboardingCubit(totalPages: 3),
          ),
          BlocProvider(create: (context) => LoginValidationCubit()),
          BlocProvider(
            create: (context) => SignupValidationCubit(),
          ),
        ],
        child: MaterialApp(
          title: ApplicationStrings.appName,
          theme: AppTheme.lightTheme,
          home: const SplashView(),
        ),
      ),
    );
  }

}
