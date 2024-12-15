import 'package:flutter/material.dart';

import '../widgets/my_scaffold.dart';
import '../widgets/primary_button.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool isActive = true;

  void onPlay() {}

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      isGame: true,
      body: Column(
        children: [
          Spacer(),
          // game board
          Spacer(),
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
