import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:pawsome/core/theme/app_colors.dart';
import 'package:pawsome/core/theme/app_fonts.dart';
import 'package:pawsome/data/auth/models/user_sign_in_req.dart';
import 'package:pawsome/presentation/auth/pages/register.dart';
import 'package:pawsome/presentation/auth/widgets/auth_form.dart';
import '../../../common/validator.dart';
import '../../../core/theme/app_strings.dart';
import '../../../core/theme/app_values.dart';
import '../bloc/auth_cubit.dart';

class LoginScreen extends StatefulWidget {
  static const String id = '/login';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailFormKey = GlobalKey<FormState>();
  final passwordFormKey = GlobalKey<FormState>();

  late FocusNode emailNode;
  late FocusNode passwordNode;

  late TextEditingController emailTextEditingController;
  late TextEditingController passwordTextEditingController;

  bool passwordVisible = false;

  @override
  void initState() {
    super.initState();
    emailNode = FocusNode();
    passwordNode = FocusNode();

    emailTextEditingController = TextEditingController();
    passwordTextEditingController = TextEditingController();

    Future.delayed(const Duration(milliseconds: 100), () {
      emailNode.requestFocus();
    });
  }

  @override
  void dispose() {
    emailTextEditingController.dispose();
    passwordTextEditingController.dispose();
    emailNode.dispose();
    passwordNode.dispose();
    super.dispose();
  }

  void loginUser(BuildContext context) async {
    if (emailFormKey.currentState!.validate() &&
        passwordFormKey.currentState!.validate()) {
      await context.read<AuthCubit>().signIn(UserSignInReq(
          email: emailTextEditingController.text.trim(),
          password: passwordTextEditingController.text.trim()));
    }
  }

  void loginWithGoogle(BuildContext context) async {
    await context.read<AuthCubit>().signInWithGoogle();
  }

  void loginWithFacebook(BuildContext context) async {
    await context.read<AuthCubit>().signInWithFacebook();
  }

  // TODO: Implement sign in with Apple
  void loginWithApple(BuildContext context) async {
    // await context.read<AuthCubit>().signInWithApple();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthError) {
                var snackBar = SnackBar(
                  content: Text(
                    state.message,
                    style: TextStyle(color: AppColors.white),
                  ),
                  backgroundColor: AppColors.grey,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                );

                HapticFeedback.heavyImpact();

                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            child: Container(
              padding: const EdgeInsets.only(top: 100, left: 40, right: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: AppSize.s40,
                    child: Image.asset(
                      'assets/images/icon_image.png',
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(
                    height: AppSize.s20,
                  ),
                  Text(
                    context.tr(AppStrings.welcomeToPawsome),
                    style: TextStyle(
                        color: AppColors.black,
                        fontSize: FontSize.s30,
                        fontWeight: FontWeightManager.semiBold,
                        fontFamily: 'PTSerif'),
                  ),
                  const SizedBox(
                    height: AppSize.s40,
                  ),
                  AuthForm(
                    globalKey: emailFormKey,
                    controller: emailTextEditingController,
                    focusNode: emailNode,
                    textInputAction: TextInputAction.next,
                    textInputType: TextInputType.emailAddress,
                    labelText: context.tr(AppStrings.email),
                    obscureText: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppStrings.enterYourEmail.tr();
                      } else if (!Validator.isEmailValid(value)) {
                        return AppStrings.enterValidEmail.tr();
                      }
                      return null;
                    },
                    onEditingComplete: () {
                      FocusScope.of(context).requestFocus(passwordNode);
                    },
                  ),
                  const SizedBox(
                    height: AppSize.s20,
                  ),
                  AuthForm(
                    globalKey: passwordFormKey,
                    controller: passwordTextEditingController,
                    focusNode: passwordNode,
                    textInputAction: TextInputAction.done,
                    textInputType: TextInputType.text,
                    obscureText: !passwordVisible,
                    enableInteractiveSelection: false,
                    letterSpacing: AppSize.s1_5,
                    labelText: context.tr(AppStrings.password),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppStrings.enterYourPassword.tr();
                      } else if (!Validator.isPasswordValid(value)) {
                        return AppStrings.enterStrongPassword.tr();
                      }
                      return null;
                    },
                    suffixIcon: IconButton(
                      icon: Icon(passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off),
                      color: Colors.grey[600]!,
                      onPressed: () {
                        setState(() {
                          passwordVisible = !passwordVisible;
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    height: AppSize.s16,
                  ),
                  GestureDetector(
                    // onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (context) => const ForgotPasswordScreen())),
                    child: Text(
                      context.tr(AppStrings.forgotPassword),
                      style: TextStyle(color: AppColors.black),
                    ),
                  ),
                  const SizedBox(
                    height: AppSize.s28,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          shape: WidgetStateProperty.all(RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(AppSize.s10)))),
                      onPressed: () {
                        loginUser(context);
                      },
                      child: Text(
                        context.tr(AppStrings.signIn),
                        style: TextStyle(
                            color: AppColors.white, fontSize: FontSize.s20),
                      ),
                    ),
                  ),
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        context.tr(AppStrings.dontHaveAccount),
                        style: const TextStyle(color: Colors.black),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const RegisterScreen()));
                        },
                        child: Text(
                          context.tr(AppStrings.signUp),
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: AppSize.s1,
                          color: AppColors.grey,
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: AppSize.s8),
                        child: Text(
                          'or',
                          style: TextStyle(
                              fontSize: FontSize.s12, color: AppColors.grey),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: AppSize.s1,
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: AppSize.s8,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: SignInButton(
                      Buttons.Facebook,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSize.s10)),
                      padding: const EdgeInsets.symmetric(vertical: AppSize.s8),
                      onPressed: () {
                        loginWithFacebook(context);
                      },
                    ),
                  ),
                  const SizedBox(
                    height: AppSize.s16,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: AppSize.s50,
                    child: SignInButton(
                      Buttons.Google,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSize.s10)),
                      padding: const EdgeInsets.symmetric(vertical: AppSize.s8),
                      onPressed: () {
                        loginWithGoogle(context);
                      },
                    ),
                  ),
                  const SizedBox(
                    height: AppSize.s16,
                  ),
                  if (Platform.isIOS)
                    SizedBox(
                      width: double.infinity,
                      height: AppSize.s50,
                      child: SignInButton(
                        Buttons.Apple,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppSize.s10)),
                        padding:
                            const EdgeInsets.symmetric(vertical: AppSize.s8),
                        onPressed: () {
                          loginWithApple(context);
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
