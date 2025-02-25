import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pawsome/presentation/auth/pages/login.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_fonts.dart';
import '../../../core/theme/app_strings.dart';
import '../../../core/theme/app_values.dart';
import '../../../core/utils/validator.dart';
import '../widgets/auth_form.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late GlobalKey<FormState> nameFormKey;
  late GlobalKey<FormState> emailFormKey;
  late GlobalKey<FormState> passwordFormKey;
  late GlobalKey<FormState> confirmPasswordFormKey;

  late FocusNode usernameNode;
  late FocusNode emailNode;
  late FocusNode passwordNode;
  late FocusNode confirmPasswordNode;

  late TextEditingController nameTextEditingController;
  late TextEditingController emailTextEditingController;
  late TextEditingController passwordTextEditingController;
  late TextEditingController confirmPasswordTextEditingController;

  @override
  void initState() {
    super.initState();
    nameFormKey = GlobalKey<FormState>();
    emailFormKey = GlobalKey<FormState>();
    passwordFormKey = GlobalKey<FormState>();
    confirmPasswordFormKey = GlobalKey<FormState>();

    usernameNode = FocusNode();
    emailNode = FocusNode();
    passwordNode = FocusNode();
    confirmPasswordNode = FocusNode();

    nameTextEditingController = TextEditingController();
    emailTextEditingController = TextEditingController();
    passwordTextEditingController = TextEditingController();
    confirmPasswordTextEditingController = TextEditingController();

    Future.delayed(const Duration(milliseconds: 100), () {
      usernameNode.requestFocus();
    });
  }

  @override
  void dispose() {
    usernameNode.dispose();
    emailNode.dispose();
    passwordNode.dispose();
    confirmPasswordNode.dispose();

    nameTextEditingController.dispose();
    emailTextEditingController.dispose();
    passwordTextEditingController.dispose();
    confirmPasswordTextEditingController.dispose();
    super.dispose();
  }

  void signUpUser(BuildContext context) async {
    if (nameFormKey.currentState!.validate() &&
        emailFormKey.currentState!.validate() &&
        passwordFormKey.currentState!.validate() &&
        confirmPasswordFormKey.currentState!.validate()) {
      //   await context.read<AuthCubit>().signIn(UserSignInReq(
      //       email: emailTextEditingController.text.trim(),
      //       password: passwordTextEditingController.text.trim()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(top: 100, left: 40, right: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sign Up',
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
                  globalKey: nameFormKey,
                  controller: nameTextEditingController,
                  focusNode: usernameNode,
                  textInputAction: TextInputAction.next,
                  textInputType: TextInputType.text,
                  labelText: context.tr(AppStrings.username),
                  obscureText: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return context.tr(AppStrings.enterUsername);
                    }
                    return null;
                  },
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus(emailNode);
                  },
                ),
                const SizedBox(
                  height: AppSize.s20,
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
                      return context.tr(AppStrings.enterYourEmail);
                    } else if (!Validator.isEmailValid(value)) {
                      return context.tr(AppStrings.enterValidEmail);
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
                  textInputAction: TextInputAction.next,
                  textInputType: TextInputType.text,
                  obscureText: true,
                  enableInteractiveSelection: false,
                  letterSpacing: AppSize.s1_5,
                  labelText: context.tr(AppStrings.password),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return context.tr(AppStrings.enterYourPassword);
                    } else if (!Validator.isPasswordValid(value)) {
                      return context.tr(AppStrings.enterStrongPassword);
                    }
                    return null;
                  },
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus(confirmPasswordNode);
                  },
                ),
                const SizedBox(
                  height: AppSize.s20,
                ),
                AuthForm(
                  globalKey: confirmPasswordFormKey,
                  controller: confirmPasswordTextEditingController,
                  focusNode: confirmPasswordNode,
                  textInputAction: TextInputAction.done,
                  textInputType: TextInputType.text,
                  obscureText: true,
                  enableInteractiveSelection: false,
                  letterSpacing: AppSize.s1_5,
                  labelText: context.tr(AppStrings.confirmPassword),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return context.tr(AppStrings.confirmYourPassword);
                    } else if (confirmPasswordTextEditingController.text
                            .trim() !=
                        passwordTextEditingController.text.trim()) {
                      return context.tr(AppStrings.passwordsNotMatch);
                    }
                    return null;
                  },
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
                            borderRadius: BorderRadius.circular(AppSize.s10)))),
                    onPressed: () {
                      signUpUser(context);
                    },
                    child: Text(
                      context.tr(AppStrings.signUp),
                      style: TextStyle(
                          color: AppColors.white, fontSize: FontSize.s20),
                    ),
                  ),
                ),
                const SizedBox(
                  height: AppSize.s10,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppSize.s10)),
                      ),
                      backgroundColor:
                          WidgetStateProperty.all(Colors.grey[800]),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                    },
                    child: Text(
                      context.tr(AppStrings.back),
                      style: TextStyle(
                          color: AppColors.white, fontSize: FontSize.s20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
