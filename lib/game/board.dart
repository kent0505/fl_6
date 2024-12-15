import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'ob.dart';
import 'prize.dart';

class PlinkoBoard extends PositionComponent {
  final int rowCount;
  final double pinSpacing;
  final double spawnBallHeight;
  final Vector2 pinSize;
  final bool isGridMode;
  final void Function(List<Vector2>) onFirstRowPinsGenerated;
  final void Function(List<Vector2>) onLastRowPinsGenerated;
  late SpriteComponent background;

  PlinkoBoard({
    required this.rowCount,
    required this.pinSpacing,
    required this.pinSize,
    required this.spawnBallHeight,
    required Vector2 size,
    required this.onFirstRowPinsGenerated,
    required this.onLastRowPinsGenerated,
    required this.isGridMode,
    super.position,
  }) {
    this.size = size;
  }

  @override
  Future<void> onLoad() async {
    final List<Vector2> firstRowPins = [];
    final List<Vector2> lastRowPins = [];
    final sprite = await Sprite.load('game.png');
    sprite.paint = Paint()..color = Colors.transparent;

    background = SpriteComponent(
      sprite: sprite,
      size: size,
      priority: -2, // Самый нижний приоритет для фона
    );
    add(background);

    if (isGridMode) {
      // Стандартная сетка: 4 ряда по 9-10 шариков
      final rowCounts = [
        9,
        10,
        9,
        10,
        9,
        10,
        9,
        10,
      ]; // Чередующееся количество шариков в рядах

      for (int row = 0; row < rowCounts.length; row++) {
        final pinCount = rowCounts[row];
        for (int column = 0; column < pinCount; column++) {
          // Пропускаем центральный пин в первом ряду
          if (row == 0 && column == pinCount ~/ 2) continue;

          final xOffset =
              size.x / 2 - (pinCount - 1) * pinSpacing / 2 - pinSize.x / 2;
          final position = Vector2(
            xOffset + column * pinSpacing,
            row * pinSpacing + spawnBallHeight,
          );

          add(Obstacle(position: position, size: pinSize));

          if (row == 0) {
            firstRowPins.add(position);
          }
          if (row == rowCounts.length - 1) {
            lastRowPins.add(position);
          }
        }
      }
    } else {
      // Пирамида
      for (int row = 0; row < rowCount; row++) {
        final pinCount = 3 + row;
        for (int column = 0; column < pinCount; column++) {
          final xOffset =
              size.x / 2 - (pinCount - 1) * pinSpacing / 2 - pinSize.x / 2;
          final position = Vector2(
            xOffset + column * pinSpacing,
            row * pinSpacing + spawnBallHeight,
          );

          add(Obstacle(position: position, size: pinSize));

          if (row == 0) {
            firstRowPins.add(position);
          }
          if (row == rowCount - 1) {
            lastRowPins.add(position);
          }
        }
      }
    }

    // Добавляем зоны с коэффициентами
    _addPrizeZones(lastRowPins);

    onFirstRowPinsGenerated(firstRowPins);
    onLastRowPinsGenerated(lastRowPins);
  }

  void _addPrizeZones(List<Vector2> lastPins) {
    if (lastPins.isEmpty) return;

    final coefficients = [10.0, 1.5, 1.0, 0.8, 0.5, 0.8, 1.0, 1.5, 10.0];
    final colors = [
      const Color(0xFFFF6B6B), // Красный
      const Color(0xFFFF9F43), // Оранжевый
      const Color(0xFFFF9F43), // Оранжевый
      const Color(0xFF2ECC71), // Зеленый
      const Color(0xFF2ECC71), // Зеленый
      const Color(0xFF2ECC71), // Зеленый
      const Color(0xFFFF9F43), // Оранжевый
      const Color(0xFFFF9F43), // Оранжевый
      const Color(0xFFFF6B6B), // Красный
    ];

    // Вычисляем размеры и позиции
    final boardWidth = lastPins.last.x - lastPins.first.x + pinSpacing;
    final containerWidth = boardWidth / coefficients.length;
    // Уменьшаем высоту контейнера
    final containerHeight = boardWidth * 0.08; // Уменьшили с 0.15 до 0.08

    // Вычисляем начальную позицию для центрирования
    final startX = (size.x - boardWidth) / 2;

    for (int i = 0; i < coefficients.length; i++) {
      final position = Vector2(
        startX + i * containerWidth, // Используем startX для центрирования
        lastPins.first.y + pinSpacing / 2,
      );

      add(PrizeZone(
        index: i,
        size: Vector2(containerWidth, containerHeight),
        coefficient: coefficients[i],
        color: colors[i],
      )..position = position);
    }
  }
}
