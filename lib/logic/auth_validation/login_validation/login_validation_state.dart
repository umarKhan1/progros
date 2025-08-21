// cubit/login_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progros/logic/auth_validation/login_validation/login_validation_cubit.dart';



class LoginValidationCubit extends Cubit<LoginValidationState> {
  LoginValidationCubit() : super(LoginValidationState());

  void emailChanged(String value) {
    emit(state.copyWith(email: value));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: value));
  }
    void togglePasswordVisibility() {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
  }
  // ignore: avoid_positional_boolean_parameters
  void toggleRememberMe(bool value) {
    emit(state.copyWith(rememberMe: value));
  }

  void submit() {
    String? emailError;
    String? passwordError;

    if (state.email.isEmpty) {
      emailError = "Email can't be empty";
    } else if (!state.email.contains('@') || !state.email.contains('.')) {
      emailError = 'Invalid email address';
    }

    if (state.password.isEmpty) {
      passwordError = "Password can't be empty";
    } else if (state.password.length < 8) {
      passwordError = 'Minimum 8 characters required';
    }

    final hasError = emailError != null || passwordError != null;

    emit(state.copyWith(
      emailError: emailError,
      passwordError: passwordError,
      submitted: true,
    ));

    if (!hasError) {
     
    }
  }
}
