import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';

import 'ob.dart';

class InvisiblePin extends Obstacle {
  InvisiblePin({
    required super.position,
    required super.size,
  }) {
    isLeftEdge = position.x < size.x * 2;
    isRightEdge = !isLeftEdge;
  }

  @override
  Future<void> onLoad() async {
    add(RectangleHitbox());
  }

  @override
  void render(Canvas canvas) {
    // Uncomment for debugging
    // final paint = Paint()..color = Colors.green;
    // canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), paint);
  }
}
