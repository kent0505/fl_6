import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../blocs/coins/coins_bloc.dart';
import '../game/game_screen.dart';
import '../utils.dart';
import '../wheel/wheel_screen.dart';
import '../widgets/my_button.dart';
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return GameScreen();
                  },
                ),
              );
            },
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
  late Timer _timer;
  int timestamp = 0;
  int seconds = 0;

  Future<void> saveTimestamp() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('timestamp', getTimestamp());
  }

  Future<void> loadTimestamp() async {
    final prefs = await SharedPreferences.getInstance();
    timestamp = prefs.getInt('timestamp') ?? 0;
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    seconds = (timestamp + 86400) - now; // 86400
    if (seconds < 0) seconds = 0;
    setState(() {});
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (seconds > 0) {
          seconds--;
        } else {
          _timer.cancel();
        }
      });
    });
  }

  String _formatTime(int seconds) {
    final duration = Duration(seconds: seconds);
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final secs = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$secs';
  }

  @override
  void initState() {
    super.initState();
    loadTimestamp();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
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
            BlocBuilder<CoinsBloc, CoinsState>(
              builder: (context, state) {
                if (state is CoinsLoaded) {
                  final isAvailable = seconds <= 0;

                  return Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: SizedBox(
                      width: 220,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Text(
                            isAvailable
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
                            isAvailable ? '' : _formatTime(seconds),
                            style: TextStyle(
                              color: Color(0xffF6D303),
                              fontSize: 24,
                              fontFamily: 'w900',
                            ),
                          ),
                          Spacer(),
                          MyButton(
                            onPressed: isAvailable
                                ? () async {
                                    await showDialog(
                                      context: context,
                                      useSafeArea: false,
                                      barrierDismissible: false,
                                      builder: (context) {
                                        return WheelScreen();
                                      },
                                    ).then((value) async {
                                      await saveTimestamp();
                                      await loadTimestamp();
                                      startTimer();
                                    });
                                  }
                                : null,
                            minSize: 24,
                            child: Text(
                              'Get Daily Bonus',
                              style: TextStyle(
                                color: isAvailable
                                    ? Color(0xffF6D303)
                                    : Color(0xffAFA5B8),
                                fontSize: 20,
                                fontFamily: 'w700',
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  );
                }

                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}
