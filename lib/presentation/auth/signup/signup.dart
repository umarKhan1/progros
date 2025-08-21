import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:progros/core/constant/app_image_const.dart';
import 'package:progros/core/constant/app_stringconst.dart';
import 'package:progros/core/extension/app_routes_ext.dart';
import 'package:progros/core/extension/sizedbox_ext.dart';
import 'package:progros/logic/auth_validation/signup_validation/sign_up_vaildation_state.dart';
import 'package:progros/logic/auth_validation/signup_validation/signup_validation_cubit.dart';
import 'package:progros/presentation/auth/login/login_view.dart';
import 'package:progros/presentation/widget/already_haveac.dart';
import 'package:progros/widget/app_button.dart';
import 'package:progros/widget/text_fields.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: .50.sh,
              width: double.infinity,
              child: Image.asset(
                ApplicationImagesStrings
                    .loginimage, // replace with your image path
                fit: BoxFit.cover,
              ),
            ),
            20.hsb,

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ApplicationStrings.createAccount,
                    style: TextStyle(
                      fontSize: 25.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  2.hsb,
                  Text(
                    ApplicationStrings.quicklyCreateAccount,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  15.hsb,
                  BlocBuilder<SignupValidationCubit, SignupValidationState>(
                    builder: (context, state) {
                      final signupValidationCubit = context
                          .read<SignupValidationCubit>();
                      return Column(
                        children: [
                          CustomTextField(
                            hint: ApplicationStrings.email,
                            iconString: ApplicationImagesStrings.email,
                            controller: emailController,
                            errorText: state.emailError,
                            onChanged: signupValidationCubit.emailChanged,
                          ),
                          5.hsb,
                          CustomTextField(
                            hint: ApplicationStrings.phone,
                            iconString: ApplicationImagesStrings.phone,
                            controller: phoneController,
                            errorText: state.phoneError,
                            onChanged: signupValidationCubit.phoneNumberChanged,
                          ),
                          5.hsb,
                          CustomTextField(
                            hint: ApplicationStrings.password,
                            iconString: ApplicationImagesStrings.password,
                            obscureText: state.obscurePassword,
                            showEye: true,
                            onEyeTap:
                                signupValidationCubit.togglePasswordVisibility,
                            controller: passwordController,
                            errorText: state.passwordError,
                            onChanged: signupValidationCubit.passwordChanged,
                          ),
                          10.hsb,
                          ApplicationButton(
                            title: ApplicationStrings.signUp,
                            onPressed: () {
                              signupValidationCubit.submit();
                              final s = signupValidationCubit.state;
                              if (s.emailError == null &&
                                  s.passwordError == null &&
                                  s.phoneError == null) {}

                              // Handle login button press
                            },
                          ),
                          15.hsb,
                          AlreadyAndDontHaveAccountText(
                            isFromLogin: true,
                            onLoginTap: () {
                              context.pushReplacement(const LoginScreen());
                            },
                          ),
                        ],
                      );
                    },
                  ),
                  20.hsb,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
