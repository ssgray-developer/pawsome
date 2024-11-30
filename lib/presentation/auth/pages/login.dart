import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:pawsome/core/theme/app_colors.dart';
import 'package:pawsome/core/theme/app_fonts.dart';
import 'package:pawsome/data/auth/models/user_sign_in_req.dart';
import 'package:pawsome/presentation/auth/widgets/auth_form.dart';
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
  final _emailFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();

  late FocusNode _emailNode;
  late FocusNode _passwordNode;

  late TextEditingController _emailTextEditingController;
  late TextEditingController _passwordTextEditingController;

  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    _emailNode = FocusNode();
    _passwordNode = FocusNode();

    _emailTextEditingController = TextEditingController();
    _passwordTextEditingController = TextEditingController();

    Future.delayed(const Duration(milliseconds: 100), () {
      _emailNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _emailTextEditingController.dispose();
    _passwordTextEditingController.dispose();
    _emailNode.dispose();
    _passwordNode.dispose();
    super.dispose();
  }

  void loginUser(BuildContext context) async {
    if (_emailFormKey.currentState!.validate() &&
        _passwordFormKey.currentState!.validate()) {
      context.read<AuthCubit>().signIn(UserSignInReq(
          email: _emailTextEditingController.text.trim(),
          password: _passwordTextEditingController.text.trim()));
    }
  }

  void loginWithGoogle(BuildContext context) async {
    await context.read<AuthCubit>().signInWithGoogle();
  }

  void loginWithFacebook(BuildContext context) async {
    await context.read<AuthCubit>().signInWithFacebook();
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
                      'Welcome to Pawsome',
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
                      controller: _emailTextEditingController,
                      focusNode: _emailNode,
                      validatorText: context.tr(AppStrings.enterValidEmail),
                      labelText: context.tr(AppStrings.email),
                      obscureText: false,
                    ),
                    const SizedBox(
                      height: AppSize.s20,
                    ),
                    AuthForm(
                      controller: _passwordTextEditingController,
                      focusNode: _passwordNode,
                      validatorText: context.tr(AppStrings.enterYourPassword),
                      obscureText: true,
                      enableInteractiveSelection: false,
                      letterSpacing: AppSize.s1_5,
                      labelText: context.tr(AppStrings.password),
                      suffixIcon: IconButton(
                        icon: Icon(_passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off),
                        color: Colors.grey[600]!,
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
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
                            shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
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
                            // Navigator.of(context).push(
                            //     MaterialPageRoute(
                            //         builder: (context) =>
                            //             RegisterScreen()));
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSize.s8),
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
                        padding:
                            const EdgeInsets.symmetric(vertical: AppSize.s8),
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
                        padding:
                            const EdgeInsets.symmetric(vertical: AppSize.s8),
                        onPressed: () {
                          loginWithGoogle(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
