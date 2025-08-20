import 'package:flutter_bloc/flutter_bloc.dart';

enum SplashState { initial, loading, completed }
class SplashCubit extends Cubit<SplashState> {

  SplashCubit() : super(SplashState.initial);
  Future<void> start() async {
    emit(SplashState.loading);

    // ignore: inference_failure_on_instance_creation
    await Future.delayed(const Duration(seconds: 2));

    // Logic: auth check, onboarding flag, etc.
    emit(SplashState.completed);
  }
}
