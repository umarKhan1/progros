import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:progros/core/constant/app_stringconst.dart';
import 'package:progros/core/extension/app_routes_ext.dart';

import 'package:progros/features/presentation/wc_screen.dart';
import 'package:progros/logic/onboarding.dart/on_boarding_cubit.dart';
import 'package:progros/logic/onboarding.dart/onboarding_state.dart';
import 'package:progros/models/on_boardingmodel.dart';
import 'package:progros/widget/app_button.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              /// Top image section
              SizedBox(
                height: constraints.maxHeight > 700 ? 0.65.sh : 0.55.sh,
                width: double.infinity,
                child: PageView.builder(
                  controller: _controller,
                  itemCount: OnboardingPageModel.onboardingPages.length,
                  onPageChanged: (index) =>
                      context.read<OnboardingCubit>().updatePage(index),
                  itemBuilder: (context, index) {
                    return Image.asset(
                      OnboardingPageModel.onboardingPages[index].image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    );
                  },
                ),
              ),

              /// Bottom content
              Align(
                alignment: Alignment.bottomCenter,
                child: ClipPath(
                  clipper: TopRoundedContainerClipper(),
                  child: Container(
                    width: double.infinity,
                    height: constraints.maxHeight > 700 ? 0.5.sh : 0.55.sh,
                    color: Colors.white,
                    alignment: Alignment.center,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: 0.06.sw,
                        vertical: 0.04.sh,
                      ),
                      child: BlocBuilder<OnboardingCubit, OnboardingState>(
                        builder: (context, state) {
                          final page =
                              OnboardingPageModel.onboardingPages[state.page];
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 32.h),
                              Text(
                                page.title,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                page.subtitle,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 32.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  OnboardingPageModel.onboardingPages.length,
                                  (i) => AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    margin: EdgeInsets.symmetric(
                                      horizontal: 0.01.sw,
                                    ),
                                    width: i == state.page ? 0.025.sw : 0.02.sw,
                                    height: i == state.page
                                        ? 0.025.sw
                                        : 0.02.sw,
                                    decoration: BoxDecoration(
                                      color: i == state.page
                                          ? Colors.green
                                          : Colors.grey.shade300,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 24.h),
                              ApplicationButton(
                                title: state.isLastPage
                                    ? ApplicationStrings.getStarted
                                    : ApplicationStrings.next,
                                onPressed: () {
                                  if (state.isLastPage) {
                                    context.pushReplacement(
                                      const WelcomeScreen(),
                                    );
                                  } else {
                                    _controller.nextPage(
                                      duration: const Duration(
                                        milliseconds: 400,
                                      ),
                                      curve: Curves.easeInOut,
                                    );
                                    context.read<OnboardingCubit>().nextPage();
                                  }
                                },
                              
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Top rounded arc
class TopRoundedContainerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(0, 80.h)
      ..quadraticBezierTo(size.width / 2, 0, size.width, 80.h)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
