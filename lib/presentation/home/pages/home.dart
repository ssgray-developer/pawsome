import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pawsome/core/theme/app_colors.dart';
import 'package:pawsome/presentation/adoption/pages/adoption.dart';
import 'package:pawsome/presentation/home/widgets/paw_button.dart';
import 'package:pawsome/presentation/message/pages/message.dart';
import 'package:pawsome/presentation/profile/pages/profile.dart';
import 'package:pawsome/presentation/shorts/pages/shorts.dart';
import 'package:pawsome/presentation/store/pages/store.dart';
import '../widgets/bnb_custom_painter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 2;

  setBottomBarIndex(index) {
    setState(() {
      currentIndex = index;
    });
  }

  // Method to get content based on the selected index
  Widget _getContentWidget(int index) {
    switch (index) {
      case 0:
        return const StoreScreen();
      case 1:
        return const ShortsScreen();
      case 2:
        return const AdoptionScreen();
      case 3:
        return const MessageScreen();
      default:
        return const ProfileScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    // Phoenix.rebirth(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        // backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            // AnimatedSwitcher for smooth content change
            Positioned.fill(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _getContentWidget(
                    currentIndex), // Get content based on the current index
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: SizedBox(
                width: size.width,
                height: 80,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CustomPaint(
                      size: Size(size.width, 80),
                      painter: BNBCustomPainter(),
                    ),
                    Center(
                      heightFactor: 0.7,
                      child: PawButton(onPressed: () {
                        setBottomBarIndex(2);
                      }),
                    ),
                    SizedBox(
                      width: size.width,
                      height: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                padding: EdgeInsets.zero,
                                constraints:
                                    const BoxConstraints(maxHeight: 20),
                                icon: Icon(
                                  Icons.store_rounded,
                                  size: 30,
                                  color: currentIndex == 0
                                      ? AppColors.primary
                                      : Colors.grey[600],
                                ),
                                onPressed: () {
                                  setBottomBarIndex(0);
                                },
                                splashColor: Colors.white,
                              ),
                              Text(
                                'Store',
                                style: TextStyle(
                                  color: currentIndex == 0
                                      ? AppColors.primary
                                      : Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints:
                                      const BoxConstraints(maxHeight: 20),
                                  icon: Icon(
                                    Icons.play_circle_outline_outlined,
                                    size: 30,
                                    color: currentIndex == 1
                                        ? AppColors.primary
                                        : Colors.grey[600],
                                  ),
                                  onPressed: () {
                                    setBottomBarIndex(1);
                                  }),
                              Text(
                                'Shorts',
                                style: TextStyle(
                                  color: currentIndex == 1
                                      ? AppColors.primary
                                      : Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: size.width * 0.20,
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints:
                                      const BoxConstraints(maxHeight: 20),
                                  icon: Icon(
                                    Icons.message,
                                    size: 30,
                                    color: currentIndex == 3
                                        ? AppColors.primary
                                        : Colors.grey[600],
                                  ),
                                  onPressed: () {
                                    setBottomBarIndex(3);
                                  }),
                              Text(
                                'Messages',
                                style: TextStyle(
                                  color: currentIndex == 3
                                      ? AppColors.primary
                                      : Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints:
                                      const BoxConstraints(maxHeight: 20),
                                  icon: Icon(
                                    Icons.account_circle_outlined,
                                    size: 30,
                                    color: currentIndex == 4
                                        ? AppColors.primary
                                        : Colors.grey[600],
                                  ),
                                  onPressed: () {
                                    setBottomBarIndex(4);
                                  }),
                              Text(
                                'Profile',
                                style: TextStyle(
                                  color: currentIndex == 4
                                      ? AppColors.primary
                                      : Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// ElevatedButton(
// onPressed: () {
// context.read<AuthCubit>().signOutFromGoogle();
// },
// child: const Text(
// 'Sign Out',
// ))
