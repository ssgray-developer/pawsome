import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:pawsome/core/theme/app_strings.dart';
import 'package:pawsome/core/theme/app_values.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pawsome/presentation/profile/pages/pet_adoption_listing.dart';
import '../../bloc/auth/auth_cubit.dart';
import '../widgets/profile_list_tile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String appVersion = "";
  String buildVersion = "";

  @override
  void initState() {
    super.initState();
    getAppVersion();
  }

  Future<void> getAppVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = packageInfo.version;
      buildVersion = packageInfo.buildNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 100),
          child: BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state is AuthAuthenticated) {
                final user = state.user;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          context.tr(AppStrings.profile),
                          style: TextStyle(
                              fontSize: 35,
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w600),
                        ),
                        Icon(
                          Platform.isIOS
                              ? CupertinoIcons.bell
                              : Icons.notifications_outlined,
                          color: Colors.grey[800],
                          size: 40,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ProfileListTile(
                          leadingWidget: CircleAvatar(
                            radius: 30,
                            foregroundImage: NetworkImage(user.photoUrl),
                            backgroundImage: const AssetImage(
                                'assets/images/default_picture.png'),
                          ),
                          title: user.username,
                          subtitle: 'Show profile',
                          onTap: () {},
                        )),
                    Divider(
                      color: Colors.grey[500],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      context.tr(AppStrings.settings),
                      style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 22,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ProfileListTile(
                      leadingWidget: Icon(
                        Icons.security_rounded,
                        color: Colors.grey[800],
                        size: 35,
                      ),
                      title: context.tr(AppStrings.loginAndSecurity),
                      onTap: () {},
                    ),
                    Divider(
                      color: Colors.grey[500],
                    ),
                    ProfileListTile(
                      leadingWidget: Icon(
                        Icons.lock_clock_rounded,
                        color: Colors.grey[800],
                        size: 35,
                      ),
                      title: context.tr(AppStrings.privacy),
                      onTap: () {},
                    ),
                    Divider(
                      color: Colors.grey[500],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      context.tr(AppStrings.petAdoption),
                      style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 22,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ProfileListTile(
                      leadingWidget: Image.asset(
                        'assets/images/icon_image.png',
                        width: 33,
                        height: 25,
                        color: Colors.grey[800],
                      ),
                      title: context.tr(AppStrings.listYourPet),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const PetAdoptionListing()));
                      },
                    ),
                    Divider(
                      color: Colors.grey[500],
                    ),
                    ProfileListTile(
                      leadingWidget: Icon(
                        Icons.list,
                        color: Colors.grey[800],
                        size: 35,
                      ),
                      title: context.tr(AppStrings.viewYourPets),
                      onTap: () {},
                    ),
                    Divider(
                      color: Colors.grey[500],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      context.tr(AppStrings.support),
                      style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 22,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ProfileListTile(
                      leadingWidget: Icon(
                        Icons.mode_edit_outline_rounded,
                        color: Colors.grey[800],
                        size: 35,
                      ),
                      title: context.tr(AppStrings.giveUsFeedback),
                      onTap: () {},
                    ),
                    Divider(
                      color: Colors.grey[500],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextButton(
                      onPressed: () async {
                        await context.read<AuthCubit>().signOut();

                        // Use Future.delayed or navigate safely after the async operation
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (mounted) {
                            // Safe to call Phoenix.rebirth(context) after the async operation completes
                            Phoenix.rebirth(context);
                          }
                        });
                      },
                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                      child: Text(
                        context.tr(AppStrings.logout),
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.grey[800],
                            fontSize: AppSize.s18,
                            color: Colors.grey[800]),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'VERSION $appVersion ($buildVersion)',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                );
              }
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
