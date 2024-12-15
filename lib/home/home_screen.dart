import 'dart:async';

import 'package:fl_6/wheel/wheel_screen.dart';
import 'package:fl_6/widgets/my_button.dart';
import 'package:flutter/material.dart';

import '../widgets/my_scaffold.dart';
import '../widgets/primary_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      isHome: true,
      body: Column(
        children: [
          SizedBox(height: 16),
          _DailyBonus(),
          Spacer(),
          PrimaryButton(
            title: 'Play Game',
            onPressed: () {},
          ),
          SizedBox(height: 60),
        ],
      ),
    );
  }
}

class _DailyBonus extends StatefulWidget {
  const _DailyBonus();

  @override
  State<_DailyBonus> createState() => _DailyBonusState();
}

class _DailyBonusState extends State<_DailyBonus> {
  bool available = true;

  late Timer _timer;
  late DateTime _currentTime;

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        _currentTime = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatTime(DateTime time) {
    return "${time.hour.toString().padLeft(2, '0')}:"
        "${time.minute.toString().padLeft(2, '0')}:"
        "${time.second.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xff4400A7),
            Color(0xff090034),
          ],
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Positioned(
              top: -20,
              right: -210,
              child: Center(
                child: Image.asset(
                  'assets/wheel.png',
                  height: 358,
                  width: 358,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: SizedBox(
                width: 220,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Text(
                      available
                          ? 'Your daily bonus is available now'
                          : 'Your daily bonus will be available',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'w700',
                      ),
                    ),
                    Spacer(),
                    Text(
                      _formatTime(_currentTime),
                      style: TextStyle(
                        color: Color(0xffF6D303),
                        fontSize: 24,
                        fontFamily: 'w900',
                      ),
                    ),
                    Spacer(),
                    MyButton(
                      onPressed: available
                          ? () {
                              showDialog(
                                context: context,
                                useSafeArea: false,
                                builder: (context) {
                                  return WheelScreen();
                                },
                              );
                            }
                          : null,
                      minSize: 24,
                      child: Text(
                        'Get Daily Bonus',
                        style: TextStyle(
                          color:
                              available ? Color(0xffF6D303) : Color(0xffAFA5B8),
                          fontSize: 20,
                          fontFamily: 'w700',
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
