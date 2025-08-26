import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progros/logic/bottom_nav/bottom_cubit.dart';
import 'package:progros/logic/bottom_nav/bottom_state.dart';
import 'package:progros/presentation/bottomnavigation/widget/bottom_navigation_widget.dart';
import 'package:progros/presentation/dashboard/dashboard.dart';
import 'package:progros/presentation/demopage.dart';
import 'package:progros/presentation/wishlist/wishlist_screen.dart';

class BottomNavigationScreen extends StatelessWidget {
  const BottomNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavigationCubit, BottomNavigationState>(
      builder: (context, state) {
        final pages = [
          Dashboard(key: state.pageKeys[0]),
          const WishlistScreen(),
          const DemoPage(),
          const DemoPage(), // Replace with actual pages
  
        ];
        return Scaffold(
          body: pages[state.index],
          bottomNavigationBar: BottomNavBarWidget(
            currentIndex: state.index,
            onTap: context.read<BottomNavigationCubit>().onTabTapped,
          ),
        );
      },
    );
  }
}
