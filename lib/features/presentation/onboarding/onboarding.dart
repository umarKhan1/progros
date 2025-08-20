import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:progros/core/constant/app_stringconst.dart';
import 'package:progros/core/extension/sizedbox_ext.dart';
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
      body: Stack(
        children: [
          /// Top half image
          SizedBox(
            height: 500.h,
            width: double.infinity,
            child: PageView.builder(
              pageSnapping: false,
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
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipPath(
              clipper: TopRoundedContainerClipper(),
              child: Container(
                width: double.infinity,
                height: 400.h,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
                color: Colors.white,
                child: BlocBuilder<OnboardingCubit, OnboardingState>(
                  builder: (context, state) {
                    final page =
                        OnboardingPageModel.onboardingPages[state.page];
                    return Column(
                      children: [
                        60.hsb,
                        Text(
                          page.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 25.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        16.hsb,
                        Text(
                          page.subtitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                        ),
                        51.hsb,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            OnboardingPageModel.onboardingPages.length,
                            (i) => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: EdgeInsets.symmetric(horizontal: 4.w),
                              width: i == state.page ? 10.w : 8.w,
                              height: i == state.page ? 10.w : 8.w,
                              decoration: BoxDecoration(
                                color: i == state.page
                                    ? Colors.green
                                    : Colors.grey.shade300,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                        24.hsb,

                        /// Action button
                        ApplicationButton(
                          title: state.isLastPage
                              ? ApplicationStrings.getStarted
                              : ApplicationStrings.next,
                          onPressed: () {
                            if (state.isLastPage) {
                            } else {
                              _controller.nextPage(
                                duration: const Duration(milliseconds: 400),
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
        ],
      ),
    );
  }
}

/// Custom clipper for top arc
class TopRoundedContainerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(0, 80.h)
      ..quadraticBezierTo(size.width / 2, 0, size.width, 80.h)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
