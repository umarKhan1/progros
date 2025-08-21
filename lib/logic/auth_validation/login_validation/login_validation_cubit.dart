class LoginValidationState {

  LoginValidationState({
    this.email = '',
    this.password = '',
    this.rememberMe = false,
    this.emailError,
    this.passwordError,
    this.obscurePassword = true,
   
    this.submitted = false,
  });
  final String email;
  final String password;
  final bool rememberMe;
 final bool obscurePassword;
  final String? emailError;
  final String? passwordError;
  final bool submitted;

  LoginValidationState copyWith({
    String? email,
    String? password,
    bool? rememberMe,
    String? emailError,
    bool? obscurePassword,
    String? passwordError,
    bool? submitted,
  }) {
    return LoginValidationState(
      email: email ?? this.email,
      password: password ?? this.password,
      rememberMe: rememberMe ?? this.rememberMe,
      emailError: emailError,
      passwordError: passwordError,
       obscurePassword: obscurePassword ?? this.obscurePassword,
      submitted: submitted ?? this.submitted,
    );
  }
}
