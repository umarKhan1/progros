class SignupValidationState {

  SignupValidationState({
    this.email = '',
    this.password = '',
    this.rememberMe = false,
    this.emailError,
    this.phoneNumber,
    this.phoneError,
    this.passwordError,
    this.obscurePassword = true,
   
    this.submitted = false,
  });
  final String email;
  final String password;
  final bool rememberMe;
 final bool obscurePassword;
 final String? phoneNumber;
  final String? phoneError;
  final String? emailError;
  final String? passwordError;
  final bool submitted;

  SignupValidationState copyWith({
    String? email,
    String? password,
    bool? rememberMe,
    String? emailError,
    bool? obscurePassword,
    String? passwordError,
    bool? submitted,
    String? phoneNumber,
    String? phoneError,
  }) {
    return SignupValidationState(
      email: email ?? this.email,
      password: password ?? this.password,
      rememberMe: rememberMe ?? this.rememberMe,
      emailError: emailError,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      phoneError: phoneError ?? this.phoneError,
      passwordError: passwordError,
       obscurePassword: obscurePassword ?? this.obscurePassword,
      submitted: submitted ?? this.submitted,
    );
  }
}
