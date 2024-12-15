import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'ball.dart';
import 'board.dart';

class PlinkoGame extends FlameGame with HasCollisionDetection {
  final bool isGridMode;
  final int rowCount = 8;
  final double pinSpacing = 60;
  final Vector2 pinSize = Vector2(20, 20);
  final double spawnBallHeight = 100;
  final Function(double prize) onPrizeCollected;
  final Function(bool isPlaying) onGameStateChanged;

  final List<Vector2> firstRowPins = [];
  final List<Vector2> lastRowPins = [];
  final Random random = Random();

  Function(double)? onWin;
  int activeBalls = 0;

  late World plinkoWorld;
  Vector2 worldBounds = Vector2.zero();

  PlinkoGame({
    required this.isGridMode,
    required this.onPrizeCollected,
    required this.onGameStateChanged,
  });

  @override
  Color backgroundColor() => const Color.fromARGB(0, 255, 255, 255);

  @override
  Future<void> onLoad() async {
    plinkoWorld = World();
    add(plinkoWorld);

    camera = CameraComponent(world: plinkoWorld)..viewfinder.zoom = 1.0;
    add(camera);

    final boardHeight = rowCount * pinSpacing + spawnBallHeight;
    final boardWidth = (3 + rowCount - 1) * pinSpacing;
    worldBounds = Vector2(boardWidth, boardHeight);

    adjustCameraToObject(worldBounds);

    final board = PlinkoBoard(
      rowCount: rowCount,
      pinSpacing: pinSpacing,
      pinSize: pinSize,
      spawnBallHeight: spawnBallHeight,
      size: worldBounds,
      position: Vector2.zero(),
      isGridMode: isGridMode,
      onFirstRowPinsGenerated: (pins) => firstRowPins.addAll(pins),
      onLastRowPinsGenerated: (pins) => lastRowPins.addAll(pins),
    );

    plinkoWorld.add(board);
  }

  void adjustCameraToObject(Vector2 objectSize) {
    final scaleX = size.x / objectSize.x;
    final scaleY = size.y / objectSize.y;
    camera.viewfinder.zoom = min(scaleX, scaleY);
    camera.viewfinder.position = objectSize / 2;
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    adjustCameraToObject(worldBounds);
  }

  PlinkoBall createBall() {
    if (firstRowPins.isEmpty) {
      throw Exception('Game not initialized properly');
    }

    Vector2 ballPosition;

    if (isGridMode) {
      final boardCenterX = worldBounds.x / 2;
      ballPosition = Vector2(
        boardCenterX,
        spawnBallHeight / 1.7,
      );
    } else {
      final randomOffset = random.nextDouble() * pinSize.x - pinSize.x / 2;
      ballPosition = Vector2(
        firstRowPins[1].x + randomOffset,
        firstRowPins.first.y - spawnBallHeight / 2,
      );
    }

    return PlinkoBall(
      position: ballPosition,
      world: plinkoWorld,
      worldBounds: worldBounds,
      onDestroyBall: (_) {
        activeBalls--;
        if (activeBalls <= 0) {
          onGameStateChanged(false);
        }
      },
      onPrizeCollected: onPrizeCollected,
    );
  }

  void spawnAndStartBall() {
    final ball = createBall();
    onGameStateChanged(true);
    activeBalls++;
    plinkoWorld.add(ball);
  }

  bool get isActive => activeBalls > 0;
}
