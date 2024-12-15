import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Obstacle extends PositionComponent with CollisionCallbacks {
  bool isLeftEdge = false;
  bool isRightEdge = false;

  Obstacle({required Vector2 position, required Vector2 size}) {
    this.position = position;
    this.size = size;
  }

  @override
  Future<void> onLoad() async {
    add(CircleHitbox());
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = Colors.purple;
    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2),
      size.x / 2,
      paint,
    );
  }
}
