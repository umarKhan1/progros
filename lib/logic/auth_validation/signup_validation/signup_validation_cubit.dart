import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progros/logic/auth_validation/signup_validation/sign_up_vaildation_state.dart';

class SignupValidationCubit extends Cubit<SignupValidationState> {
  SignupValidationCubit() : super(SignupValidationState());

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

  void phoneNumberChanged(String value) {
    emit(state.copyWith(phoneNumber: value));
  }

  void submit() {
    String? emailError;
    String? passwordError;
    String? phoneError;

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
    if (state.phoneNumber == null || state.phoneNumber!.isEmpty) {
      phoneError = "Phone number can't be empty";
    } else if (state.phoneNumber!.length < 10) {
      phoneError = 'Invalid phone number';
    }
    final hasError =
        emailError != null || passwordError != null || phoneError != null;

    emit(
      state.copyWith(
        emailError: emailError,
        passwordError: passwordError,
        phoneError: phoneError,
        submitted: true,
      ),
    );

    if (!hasError) {}
  }
}
