import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:progros/core/apptheme.dart';

import 'package:progros/core/constant/app_stringconst.dart';
import 'package:progros/features/presentation/splash_view.dart';
import 'package:progros/logic/splash_screen_cubit.dart';

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
          BlocProvider(create: (_) => SplashCubit()),
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
