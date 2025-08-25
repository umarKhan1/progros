import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:progros/logic/auth_validation/login_validation/login_validation_cubit.dart';
import 'package:progros/logic/auth_validation/signup_validation/signup_validation_cubit.dart';
import 'package:progros/logic/basket/basket_cubit.dart';
import 'package:progros/logic/location/location_cubit.dart';
import 'package:progros/logic/onboarding.dart/on_boarding_cubit.dart';
import 'package:progros/logic/product/product_cubit.dart';
import 'package:progros/logic/search/search_cubit.dart';
import 'package:progros/logic/splash_screen_cubit.dart';

class AppBlocProviders {
  static MultiBlocProvider create({required Widget child}) {
    return MultiBlocProvider(
      providers: [
        // Splash Screen Cubit
        BlocProvider(create: (_) => SplashCubit()..start()),
        
        // Onboarding Cubit
        BlocProvider(create: (context) => OnboardingCubit(totalPages: 3)),
        
        // Authentication Validation Cubits
        BlocProvider(create: (context) => LoginValidationCubit()),
        BlocProvider(create: (context) => SignupValidationCubit()),
        
        // Products Cubit
        BlocProvider(create: (_) => ProductsCubit()..init()),
        
        // Basket Cubit
        BlocProvider(create: (context) => BasketCubit()),
        
        // Search Cubit (depends on ProductsCubit)
        BlocProvider(
          create: (ctx) =>
              SearchCubit(() => ctx.read<ProductsCubit>().state.all)..init(),
        ),
        
        // Location Cubit
        BlocProvider(
          create: (context) =>
              LocationCubit(placesApiKey: dotenv.env['GOOGLE_MAP_API_KEY'])
                ..startPermissionGate(),
        ),
      ],
      child: child,
    );
  }
}