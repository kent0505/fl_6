import 'dart:async';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../blocs/coins/coins_bloc.dart';
import '../widgets/my_button.dart';
import '../widgets/my_scaffold.dart';
import '../widgets/primary_button.dart';
import 'game.dart';
import 'no_money_dialog.dart';
import 'win_dialog.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  late PlinkoGame game;
  int balls = 1;
  int bet = 10;
  List<double> collectedPrizes = [];
  bool isActive = true;
  bool isStandart = true;
  bool isFinishInProgress = false;

  void _initializeGame() {
    isFinishInProgress = false;
    game = PlinkoGame(
      isGridMode: isStandart,
      onPrizeCollected: (prize) {
        collectedPrizes.add(prize);
        if (collectedPrizes.length == balls && !isFinishInProgress) {
          isFinishInProgress = true;
          Future.delayed(Duration(seconds: 1), () {
            _finishGame();
          });
        }
      },
      onGameStateChanged: (bool isPlaying) {},
    );
  }

  void _finishGame() async {
    if (!mounted || !isFinishInProgress) return;
    isFinishInProgress = true;
    double totalWin = 0;
    for (double prize in collectedPrizes) {
      totalWin += bet * prize;
    }
    context.read<CoinsBloc>().add(SaveCoins(amount: totalWin.round()));
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WinDialog(prize: totalWin);
      },
    ).then((value) {
      setState(() {
        isActive = true;
        collectedPrizes.clear();
        _initializeGame();
      });
    });
  }

  void _restartGame() {
    isActive = true;
    setState(() {
      _initializeGame();
      collectedPrizes.clear();
    });
  }

  void onBetSize(int value) {
    bet = value;
  }

  void onNumber(int value) {
    balls = value;
  }

  void onTab(int value) {
    if (value == 1) {
      isStandart = true;
    } else {
      isStandart = false;
    }
    _restartGame();
  }

  void onPlay() async {
    final prefs = await SharedPreferences.getInstance();
    int coins = prefs.getInt('coins') ?? 300;

    if (bet * balls > coins) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) {
            return NoMoneyDialog();
          },
        );
      }
    } else {
      if (mounted) {
        context
            .read<CoinsBloc>()
            .add(SaveCoins(amount: bet * balls, isBuy: true));
      }
      setState(() {
        isActive = false;
        coins -= bet * balls;
        collectedPrizes.clear();
      });
      for (int i = 0; i < balls; i++) {
        if (!mounted) return;
        game.spawnAndStartBall();
        if (i < balls - 1) {
          await Future.delayed(const Duration(milliseconds: 200));
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      isGame: true,
      body: Column(
        children: [
          Container(
            height: 58,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Color(0xff090034),
              borderRadius: BorderRadius.circular(58),
            ),
            child: Row(
              children: [
                SizedBox(width: 8),
                _Tab(
                  id: 1,
                  title: 'Standart',
                  isSelected: isStandart,
                  onPressed: onTab,
                ),
                _Tab(
                  id: 2,
                  title: 'Hard',
                  isSelected: !isStandart,
                  onPressed: onTab,
                ),
                SizedBox(width: 8),
              ],
            ),
          ),
          Spacer(),
          Expanded(
            flex: 8,
            child: Stack(
              children: [
                GameWidget(game: game),
              ],
            ),
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 16),
              _IncDec(
                title: 'Bet size',
                isActive: isActive,
                onPressed: onBetSize,
              ),
              Spacer(),
              _IncDec(
                title: 'Number of balls',
                isActive: isActive,
                onPressed: onNumber,
              ),
              SizedBox(width: 16),
            ],
          ),
          SizedBox(height: 20),
          PrimaryButton(
            title: 'Play',
            isActive: isActive,
            onPressed: onPlay,
          ),
          SizedBox(height: 60),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({
    required this.id,
    required this.title,
    required this.isSelected,
    required this.onPressed,
  });

  final int id;
  final String title;
  final bool isSelected;
  final void Function(int) onPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 42,
        decoration: BoxDecoration(
          color: isSelected ? Color(0xff6F18FA) : Colors.transparent,
          borderRadius: BorderRadius.circular(42),
        ),
        child: MyButton(
          onPressed: () {
            onPressed(id);
          },
          minSize: 42,
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: isSelected ? 'w700' : 'w500',
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _IncDec extends StatefulWidget {
  const _IncDec({
    required this.title,
    required this.isActive,
    required this.onPressed,
  });

  final String title;
  final bool isActive;
  final void Function(int) onPressed;

  @override
  State<_IncDec> createState() => _IncDecState();
}

class _IncDecState extends State<_IncDec> {
  int value = 1;

  void onChange(bool increment) {
    increment ? value++ : value--;
    widget.onPressed(value);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'w500',
          ),
        ),
        SizedBox(height: 10),
        Container(
          height: 44,
          width: 175,
          decoration: BoxDecoration(
            color: widget.isActive ? Color(0xff6F18FA) : Color(0xff22074b),
            borderRadius: BorderRadius.circular(44),
          ),
          child: Row(
            children: [
              SizedBox(width: 16),
              MyButton(
                onPressed: !widget.isActive || value == 1
                    ? null
                    : () {
                        onChange(false);
                      },
                minSize: 44,
                child: Icon(
                  Icons.remove_rounded,
                  size: 30,
                  color: !widget.isActive || value == 1
                      ? Color(0xffAFA5B8)
                      : Colors.white,
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    value.toString(),
                    style: TextStyle(
                      color:
                          !widget.isActive ? Color(0xffAFA5B8) : Colors.white,
                      fontSize: 16,
                      fontFamily: 'w500',
                    ),
                  ),
                ),
              ),
              MyButton(
                onPressed: !widget.isActive || value == 10
                    ? null
                    : () {
                        onChange(true);
                      },
                minSize: 44,
                child: Icon(
                  Icons.add_rounded,
                  size: 30,
                  color: !widget.isActive || value == 10
                      ? Color(0xffAFA5B8)
                      : Colors.white,
                ),
              ),
              SizedBox(width: 16),
            ],
          ),
        ),
      ],
    );
  }
}
