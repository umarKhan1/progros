import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:progros/logic/auth_validation/login_validation/login_validation_state.dart';
import 'package:progros/logic/auth_validation/signup_validation/signup_validation_cubit.dart';
import 'package:progros/logic/basket/basket_cubit.dart';
import 'package:progros/logic/bottom_nav/bottom_cubit.dart';
import 'package:progros/logic/category/category_cubit.dart';
import 'package:progros/logic/location/location_cubit.dart';
import 'package:progros/logic/onboarding.dart/on_boarding_cubit.dart';
import 'package:progros/logic/product/product_cubit.dart';
import 'package:progros/logic/search/search_cubit.dart';
import 'package:progros/logic/splash_screen_cubit.dart';
import 'package:progros/logic/wishlist/wishlist_cubit.dart';
import 'package:progros/models/cat_subcat_model.dart';

class AppBlocProviders extends StatelessWidget {
  const AppBlocProviders({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SplashCubit()..start()),
        BlocProvider(create: (context) => OnboardingCubit(totalPages: 3)),
        BlocProvider(create: (context) => LoginValidationCubit()),
        BlocProvider(create: (_) => ProductsCubit()..init()),
        BlocProvider(create: (context) => BasketCubit()),
        BlocProvider(create: (context) => WishlistCubit()),
        BlocProvider(create: (context) => BottomNavigationCubit()),
        BlocProvider(
          create: (context) => CategoryCubit(
            categories: categories,
            initialCategoryId: categories.first.id,
          ),
        ),
        BlocProvider(
          create: (ctx) =>
              SearchCubit(() => ctx.read<ProductsCubit>().state.all)..init(),
        ),
        BlocProvider(create: (context) => SignupValidationCubit()),
        BlocProvider(
          create: (context) =>
              LocationCubit(placesApiKey: dotenv.env['GOOGLE_API_KEY'])
                ..startPermissionGate(),
        ),
      ],
      child: child,
    );
  }
}
