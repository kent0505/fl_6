import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils.dart';
import '../widgets/primary_button.dart';
import '../widgets/rotated_widget.dart';

class WheelScreen extends StatefulWidget {
  const WheelScreen({super.key});

  @override
  State<WheelScreen> createState() => _WheelScreenState();
}

class _WheelScreenState extends State<WheelScreen> {
  double turns = 0.0;
  double angle = 0;
  String asset = '';
  bool canSpin = true;

  List<double> angles = [
    1, // 5 0
    2, // 15 1
    3, // 15 2
    4, // 5 3
    5, // 50 4
    7, // 55 5
    12, // 25 6
    14, // 10 7
    15, // 150 8
    16, // 20 9
    19, // 1 10
    21, // 500 11
  ];

  int getCoins() {
    asset = '';
    if (angle == 1) return 5;
    if (angle == 2) return 15;
    if (angle == 3) return 15;
    if (angle == 4) return 5;
    if (angle == 5) return 50;
    if (angle == 7) return 55;
    if (angle == 12) return 25;
    if (angle == 14) return 10;
    if (angle == 15) return 150;
    if (angle == 16) return 20;
    if (angle == 19) return 1;
    if (angle == 21) return 500;
    return 0;
  }

  void getRandom() {
    Random random = Random();
    int randomIndex = random.nextInt(angles.length);
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        angle = angles[randomIndex];
        logger(angle);
      });
    });
  }

  void onSpin() async {
    setState(() {
      turns += 5 / 1;
      canSpin = false;
    });
    getRandom();
    await Future.delayed(const Duration(seconds: 7), () async {
      logger(getCoins());
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('coins', getCoins());
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return _WinDialog(
                amount: getCoins(),
              );
            },
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Spacer(),
        SizedBox(
          height: 352,
          width: 352,
          child: Stack(
            children: [
              Transform.rotate(
                angle: angle,
                child: AnimatedRotation(
                  turns: turns,
                  curve: Curves.easeInOutCirc,
                  duration: const Duration(seconds: 7),
                  child: Stack(
                    children: [
                      SvgPicture.asset('assets/wheel1.svg'),
                      _Amount(20, 0),
                      _Amount(50, 45),
                      _Amount(100, 45 + 45),
                      _Amount(300, 45 + 45 + 45),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                child: SvgPicture.asset('assets/wheel2.svg'),
              ),
            ],
          ),
        ),
        Spacer(),
        PrimaryButton(
          title: 'Spin',
          isActive: canSpin,
          onPressed: onSpin,
        ),
        SizedBox(height: 60),
      ],
    );
  }
}

class _Amount extends StatelessWidget {
  const _Amount(this.amount, this.degree);

  final int amount;
  final int degree;

  @override
  Widget build(BuildContext context) {
    return RotatedWidget(
      degree: degree,
      child: Align(
        alignment: Alignment.center,
        child: Row(
          children: [
            SizedBox(width: 76),
            Text(
              amount.toString(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: 'w900',
              ),
            ),
            Spacer(),
            Text(
              amount.toString(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: 'w900',
              ),
            ),
            SizedBox(width: 76),
          ],
        ),
      ),
    );
  }
}

class _WinDialog extends StatelessWidget {
  const _WinDialog({required this.amount});

  final int amount;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        height: 374,
        width: 328,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: RadialGradient(
            colors: [
              Color(0xff4201A4),
              Color(0xff090135),
            ],
            center: Alignment.center,
            radius: 0.7,
          ),
        ),
        child: Column(
          children: [
            Spacer(),
            Text(
              '+$amount coins',
              style: TextStyle(
                color: Color(0xffEF8521),
                fontSize: 20,
                fontFamily: 'w900',
              ),
            ),
            SizedBox(height: 18),
            PrimaryButton(
              title: 'Collect',
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
