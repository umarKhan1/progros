import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progros/logic/onboarding.dart/onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit({required this.totalPages})
      : super(const OnboardingState());
  final int totalPages;

  void updatePage(int newPage) {
    emit(state.copyWith(
      page: newPage,
      isLastPage: newPage == totalPages - 1,
    ));
  }

  void nextPage() {
    final next = (state.page + 1).clamp(0, totalPages - 1);
    updatePage(next);
  }
}
