// ignore_for_file: lines_longer_than_80_chars

import 'package:progros/core/constant/app_image_const.dart';

class OnboardingPageModel {
  const OnboardingPageModel({
    required this.title,
    required this.subtitle,
    required this.image,
  });
  final String title;
  final String subtitle;
  final String image;

  static const List<OnboardingPageModel> onboardingPages = [
    OnboardingPageModel(
      title: 'Premium Food\nAt Your Doorstep',
      subtitle:
          'Lorem ipsum dolor sit amet, consectetur sadipscing elitr, sed diam nonumy',
      image: ApplicationImagesStrings.onboarding,
    ),
    OnboardingPageModel(
      title: 'Fresh Items\nEvery Morning',
      subtitle:
          "Just order and we'll deliver to your home every morning fresh and clean.",
      image: ApplicationImagesStrings.onboarding1,
    ),
    OnboardingPageModel(
      title: 'Fast Delivery\nAnywhere',
      subtitle:
          'We deliver fast, within minutes of your order anytime, anywhere.',
      image: ApplicationImagesStrings.onboarding2,
    ),
  ];
}
