import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home/home_screen.dart';
import '../widgets/bg.dart';
import '../widgets/circle_button.dart';
import '../widgets/my_button.dart';
import '../widgets/primary_button.dart';

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({super.key});

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  int page = 1;

  void onBack() {
    if (page == 1) {
    } else {
      setState(() => page--);
    }
  }

  Future<void> onSkip() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isOnboard', false);
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) {
            return HomeScreen();
          },
        ),
        (route) => false,
      );
    }
  }

  void onNext() async {
    if (page == 3) {
      await onSkip();
    } else {
      setState(() {
        page++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Bg(),
          Column(
            children: [
              SizedBox(height: 8 + MediaQuery.of(context).viewPadding.top),
              Row(
                children: [
                  SizedBox(width: 16),
                  CircleButton(
                    asset: 'assets/back.svg',
                    onPressed: onBack,
                  ),
                  if (page < 3) ...[
                    Spacer(),
                    MyButton(
                      minSize: 24,
                      onPressed: onSkip,
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          color: Color(0xffF6D303),
                          fontSize: 20,
                          fontFamily: 'w900',
                        ),
                      ),
                    ),
                    SizedBox(width: 26),
                  ],
                ],
              ),
              Expanded(
                flex: 8,
                child: Stack(
                  children: [
                    SvgPicture.asset('assets/onboard.svg'),
                    Positioned(
                      bottom: 0,
                      right: 50,
                      child: Container(
                        height: 300,
                        width: 284,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(284),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xff4400A7),
                              Color(0xff090034),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      bottom: 0,
                      right: 0,
                      child: Image.asset(
                        'assets/o$page.png',
                        height: 320,
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Row(
                children: [
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      page == 1
                          ? 'Welcome to Plinko!'
                          : page == 2
                              ? 'Get Daily Bonus!'
                              : 'Plinko Board',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontFamily: 'w900',
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  page == 1
                      ? 'This app will help you enjoy the game of Plinko and test your luck! Join us and start your journey right now!'
                      : page == 2
                          ? 'Log in every day to claim exciting daily bonuses! The more you play, the better the rewards.  Don’t miss out—your daily prize is just a tap away!'
                          : 'Hit Play and watch the balls bounce through the Plinko board!',
                  style: TextStyle(
                    color: Color(0xffAFA5B8),
                    fontSize: 14,
                    fontFamily: 'w400',
                  ),
                ),
              ),
              Spacer(),
              PrimaryButton(
                title: page == 3 ? 'Go to Game' : 'Next',
                onPressed: onNext,
              ),
              SizedBox(height: 60),
            ],
          ),
        ],
      ),
    );
  }
}
