import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:progros/core/apptheme.dart';
import 'package:progros/core/bloc_providers.dart';
import 'package:progros/core/constant/app_stringconst.dart';
import 'package:progros/presentation/splash_view.dart';

void main() async {
  await dotenv.load(fileName: './.env');
  debugPrint('⚙️ Loaded GOOGLE_API_KEY=${dotenv.env['GOOGLE_API_KEY']}');
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
      child: AppBlocProviders(
        child: MaterialApp(
          title: ApplicationStrings.appName,
          theme: AppTheme.lightTheme,
          home: const SplashView(),
        ),
      ),
    );
  }
}
