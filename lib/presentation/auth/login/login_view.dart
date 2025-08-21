import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:progros/core/constant/app_image_const.dart';
import 'package:progros/core/constant/app_stringconst.dart';
import 'package:progros/core/extension/app_routes_ext.dart';
import 'package:progros/core/extension/sizedbox_ext.dart';
import 'package:progros/logic/auth_validation/login_validation/login_validation_cubit.dart';
import 'package:progros/logic/auth_validation/login_validation/login_validation_state.dart';
import 'package:progros/presentation/auth/signup/signup.dart';
import 'package:progros/presentation/auth/widget/already_haveac.dart';
import 'package:progros/presentation/dashboard/dashboard.dart';
import 'package:progros/widget/app_button.dart';
import 'package:progros/widget/text_fields.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
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
                    ApplicationStrings.welcome,
                    style: TextStyle(
                      fontSize: 25.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  2.hsb,
                  Text(
                    ApplicationStrings.signintoyourAccount,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  15.hsb,
                  BlocBuilder<LoginValidationCubit, LoginValidationState>(
                    builder: (context, state) {
                      final loginValidationCubit = context
                          .read<LoginValidationCubit>();
                      return Column(
                        children: [
                          CustomTextField(
                            hint: ApplicationStrings.email,
                            iconString: ApplicationImagesStrings.email,
                            controller: emailController,
                            errorText: state.emailError,
                            onChanged: loginValidationCubit.emailChanged,
                          ),
                          5.hsb,
                          CustomTextField(
                            hint: ApplicationStrings.password,
                            iconString: ApplicationImagesStrings.password,
                            obscureText: state.obscurePassword,
                            showEye: true,
                            onEyeTap:
                                loginValidationCubit.togglePasswordVisibility,
                            controller: passwordController,
                            errorText: state.passwordError,
                            onChanged: loginValidationCubit.passwordChanged,
                          ),
                          5.hsb,
                          Row(
                            children: [
                              Transform.scale(
                                scale: 0.7,
                                child: CupertinoSwitch(
                                  inactiveThumbColor: Colors.grey,

                                  inactiveTrackColor: Colors.grey[300],
                                  value: state.rememberMe,
                                  onChanged:
                                      loginValidationCubit.toggleRememberMe,
                                ),
                              ),
                              Text(
                                ApplicationStrings.remberMe,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.grey,
                                ),
                              ),
                              const Spacer(),
                              TextButton(
                                style: TextButton.styleFrom(
                                  splashFactory: NoSplash.splashFactory,
                                ),
                                onPressed: () {},
                                child: Text(
                                  ApplicationStrings.forgotPassword,
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          10.hsb,
                          ApplicationButton(
                            title: ApplicationStrings.login,
                            onPressed: () {
                              loginValidationCubit.submit();
                              final s = loginValidationCubit.state;
                              if (s.emailError == null &&
                                  s.passwordError == null) {
                                context.pushReplacement(const Dashboard());
                              }

                              // Handle login button press
                            },
                          ),
                          15.hsb,
                          AlreadyAndDontHaveAccountText(
                            isFromLogin: false,
                            onLoginTap: () {
                              context.push(const SignupScreen());
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
