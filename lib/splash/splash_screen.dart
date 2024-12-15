import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../blocs/coins/coins_bloc.dart';
import '../home/home_screen.dart';
import '../widgets/bg.dart';
import 'onboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CoinsBloc, CoinsState>(
      listener: (context, state) {
        if (state is CoinsLoaded) {
          Future.delayed(
            const Duration(seconds: 2),
            () {
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return state.isOnboard ? OnboardScreen() : HomeScreen();
                    },
                  ),
                  (route) => false,
                );
              }
            },
          );
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            Bg(),
            Center(
              child: RotationTransition(
                turns: controller,
                child: SvgPicture.asset('assets/loader.svg'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
