import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/coins/coins_bloc.dart';
import '../blocs/internet/internet_bloc.dart';
import 'bg.dart';
import 'my_appbar.dart';
import 'primary_button.dart';

class MyScaffold extends StatelessWidget {
  const MyScaffold({
    super.key,
    required this.body,
    this.title = '',
    this.isHome = false,
    this.isGame = false,
  });

  final Widget body;
  final String title;
  final bool isHome;
  final bool isGame;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BlocBuilder<CoinsBloc, CoinsState>(
            builder: (context, state) {
              if (state is CoinsLoaded) {
                return state.bg == 0
                    ? Bg()
                    : Image.asset(
                        'assets/bg${state.bg}.jpg',
                        height: double.infinity,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      );
              }

              return Bg();
            },
          ),
          BlocBuilder<InternetBloc, InternetState>(
            builder: (context, state) {
              if (state is InternetFailure) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'No internet connection',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'w900',
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'It looks like you’re offline! Please check your connection and try again to enjoy the full experience.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: 'w400',
                          ),
                        ),
                        SizedBox(height: 10),
                        PrimaryButton(
                          title: 'Retry',
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                );
              }
              return Column(
                children: [
                  MyAppbar(
                    title: title,
                    isHome: isHome,
                    isGame: isGame,
                  ),
                  Expanded(child: body),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
