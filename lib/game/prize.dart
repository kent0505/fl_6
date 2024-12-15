import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'ball.dart';

class PrizeZone extends PositionComponent with CollisionCallbacks {
  final int index;
  final double coefficient;
  final Color color;
  bool wasHit = false;
  static const double gap = 4;
  double _animationScale = 1.0;
  bool isAnimating = false;

  PrizeZone({
    required this.index,
    required Vector2 size,
    required this.coefficient,
    required this.color,
  }) {
    this.size = Vector2(size.x - gap, size.y);
    position.x += gap / 2;
    add(RectangleHitbox(
      size: this.size,
      collisionType: CollisionType.active,
    ));
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    if (other is PlinkoBall && !wasHit) {
      onBallHit(other);
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  void onBallHit(PlinkoBall ball) {
    wasHit = true;
    ball.removeFromParent();
    _startAnimation();
  }

  void _startAnimation() {
    if (!isAnimating) {
      isAnimating = true;
      _animate();
    }
  }

  void _animate() async {
    const duration = Duration(milliseconds: 150);
    const maxScale = 1.2;
    final startTime = DateTime.now();

    try {
      while (true) {
        final elapsedTime = DateTime.now().difference(startTime).inMilliseconds;
        if (elapsedTime >= duration.inMilliseconds * 2) break;
        if (elapsedTime <= duration.inMilliseconds) {
          _animationScale =
              1.0 + (maxScale - 1.0) * (elapsedTime / duration.inMilliseconds);
        } else {
          final reverseProgress =
              (elapsedTime - duration.inMilliseconds) / duration.inMilliseconds;
          _animationScale = maxScale - (maxScale - 1.0) * reverseProgress;
        }
        await Future.delayed(const Duration(milliseconds: 16));
      }
    } finally {
      _animationScale = 1.0;
      isAnimating = false;
      wasHit = false; // Сбрасываем флаг для следующего шарика
    }
  }

  @override
  void render(Canvas canvas) {
    canvas.save();

    final centerX = size.x / 2;
    final centerY = size.y / 2;
    canvas.translate(centerX, centerY);
    canvas.scale(_animationScale);
    canvas.translate(-centerX, -centerY);

    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    final paint = Paint()..color = color;

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(8)),
      paint,
    );

    final formattedCoefficient = coefficient
        .toStringAsFixed(coefficient == coefficient.roundToDouble() ? 0 : 1);
    final textPainter = TextPainter(
      text: TextSpan(
        text: '${formattedCoefficient}x',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    textPainter.layout(
      minWidth: size.x,
      maxWidth: size.x,
    );

    textPainter.paint(
      canvas,
      Offset(0, (size.y - textPainter.height) / 2),
    );

    canvas.restore();
  }
}
