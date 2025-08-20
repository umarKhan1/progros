
import 'package:equatable/equatable.dart';

class OnboardingState extends Equatable {

  const OnboardingState({this.page = 0, this.isLastPage = false});
  final int page;
  final bool isLastPage;

  OnboardingState copyWith({int? page, bool? isLastPage}) {
    return OnboardingState(
      page: page ?? this.page,
      isLastPage: isLastPage ?? this.isLastPage,
    );
  }

  @override
  List<Object> get props => [page, isLastPage];
}
