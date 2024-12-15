import 'package:flutter/material.dart';

import '../widgets/my_button.dart';
import '../widgets/my_scaffold.dart';
import '../widgets/primary_button.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool isActive = true;
  bool isStandart = true;
  int betSize = 1;
  int numberBals = 1;

  void onBetSize(int value) {
    betSize = value;
    print('BET SIZE = $betSize');
  }

  void onNumber(int value) {
    numberBals = value;
    print('NUMBER BALS = $numberBals');
  }

  void onTab(int value) {
    setState(() {
      if (value == 1) {
        isStandart = true;
      } else {
        isStandart = false;
      }
    });
  }

  void onPlay() {}

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
                Spacer(),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 16),
              _IncDec(
                title: 'Bet size',
                onPressed: onBetSize,
              ),
              Spacer(),
              _IncDec(
                title: 'Number of balls',
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
    return Container(
      height: 42,
      width: 170,
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
    );
  }
}

class _IncDec extends StatefulWidget {
  const _IncDec({
    required this.title,
    required this.onPressed,
  });

  final String title;
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
            color: Color(0xff6F18FA),
            borderRadius: BorderRadius.circular(44),
          ),
          child: Row(
            children: [
              SizedBox(width: 16),
              MyButton(
                onPressed: value == 1
                    ? null
                    : () {
                        onChange(false);
                      },
                minSize: 44,
                child: Icon(
                  Icons.remove_rounded,
                  size: 30,
                  color: value == 1 ? Color(0xffAFA5B8) : Colors.white,
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    value.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'w500',
                    ),
                  ),
                ),
              ),
              MyButton(
                onPressed: value == 10
                    ? null
                    : () {
                        onChange(true);
                      },
                minSize: 44,
                child: Icon(
                  Icons.add_rounded,
                  size: 30,
                  color: value == 10 ? Color(0xffAFA5B8) : Colors.white,
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
