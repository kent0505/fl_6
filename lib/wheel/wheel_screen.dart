import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../blocs/coins/coins_bloc.dart';
import '../widgets/primary_button.dart';
import '../widgets/rotated_widget.dart';

class WheelScreen extends StatefulWidget {
  const WheelScreen({super.key});

  @override
  State<WheelScreen> createState() => _WheelScreenState();
}

class _WheelScreenState extends State<WheelScreen> {
  double a = 0;
  double turn = 0.0;
  bool isActive = true;

  List<double> aaa = [1, 3, 4, 5, 6, 7, 8, 8.5, 10, 12, 15, 16, 17];

  int getWonCoins() {
    if (a == 1) return 50;
    if (a == 3) return 100;
    if (a == 4) return 50;
    if (a == 5) return 20;
    if (a == 6) return 100;
    if (a == 7) return 50;
    if (a == 8) return 20;
    if (a == 8.5) return 300;
    if (a == 10) return 50;
    if (a == 12) return 300;
    if (a == 15) return 300;
    if (a == 16) return 100;
    if (a == 17) return 20;
    return 0;
  }

  void getRandom() {
    Random random = Random();
    int randomIndex = random.nextInt(aaa.length);
    Future.delayed(
      const Duration(seconds: 3),
      () => setState(() => a = aaa[randomIndex]),
    );
  }

  void onSpin() async {
    setState(() {
      turn += 5 / 1;
      isActive = false;
    });
    getRandom();
    await Future.delayed(
      const Duration(seconds: 7),
      () {
        Future.delayed(
          const Duration(seconds: 1),
          () {
            if (mounted) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return _WinDialog(amount: getWonCoins());
                },
              );
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Column(
        children: [
          Spacer(),
          SizedBox(
            height: 352,
            width: 352,
            child: Stack(
              children: [
                Transform.rotate(
                  angle: a,
                  child: AnimatedRotation(
                    turns: turn,
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
            isActive: isActive,
            onPressed: onSpin,
          ),
          SizedBox(height: 60),
        ],
      ),
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
    return PopScope(
      canPop: false,
      child: Dialog(
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
              radius: 0.8,
            ),
          ),
          child: Stack(
            children: [
              SvgPicture.asset('assets/win.svg'),
              Column(
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
                      context.read<CoinsBloc>().add(SaveCoins(amount: amount));
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(height: 24),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
