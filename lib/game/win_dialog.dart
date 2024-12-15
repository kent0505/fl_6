import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../blocs/coins/coins_bloc.dart';
import '../widgets/my_button.dart';
import '../widgets/primary_button.dart';

class WinDialog extends StatelessWidget {
  const WinDialog({
    super.key,
    required this.prize,
  });

  final double prize;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: SizedBox(
        height: 370,
        width: 360,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 250,
                width: 360,
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
                child: Column(
                  children: [
                    SizedBox(height: 16),
                    Text(
                      'Reward',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'w900',
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 32,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Color(0xff6F18FA),
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: Center(
                            child: Text(
                              '+${prize.round()}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontFamily: 'w700',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Total score',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'w900',
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/coin.svg'),
                        SizedBox(width: 10),
                        BlocBuilder<CoinsBloc, CoinsState>(
                          builder: (context, state) {
                            return Text(
                              state is CoinsLoaded
                                  ? NumberFormat('###.##').format(state.coins)
                                  : '',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontFamily: 'w700',
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    Spacer(),
                    Row(
                      children: [
                        SizedBox(width: 8),
                        Expanded(
                          child: MyButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            minSize: 52,
                            child: Text(
                              'Go to Home',
                              style: TextStyle(
                                color: Color(0xffF6D303),
                                fontSize: 20,
                                fontFamily: 'w900',
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: PrimaryButton(
                            title: 'Repeat Game',
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        SizedBox(width: 8),
                      ],
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            SvgPicture.asset('assets/win2.svg'),
            Positioned(
              top: 84,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'Complete',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontFamily: 'w900',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
