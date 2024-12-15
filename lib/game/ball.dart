import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'ob.dart';
import 'prize.dart';

class PlinkoBall extends PositionComponent with CollisionCallbacks {
  Vector2 velocity = Vector2.zero();
  final double gravity = 700;
  final double restitution = 0.65;
  final Random random = Random();
  bool isDestroyed = false;
  bool hasHitPrizeZone = false;
  final Function(double prize) onPrizeCollected;
  final World world;
  final Vector2 worldBounds;

  PlinkoBall({
    required Vector2 position,
    required this.world,
    required this.worldBounds,
    required Function(String) onDestroyBall,
    required this.onPrizeCollected,
  }) {
    this.position = position;
    size = Vector2(30, 30);
    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);

    velocity.y += gravity * dt;
    position += velocity * dt;

    if (position.y > worldBounds.y && !isDestroyed) {
      isDestroyed = true;
      removeFromParent();
    }
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is PrizeZone && !hasHitPrizeZone) {
      hasHitPrizeZone = true;
      onPrizeCollected(other.coefficient);
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is Obstacle) {
      Vector2 normal =
          ((position + size / 2) - (other.position + other.size / 2))
              .normalized();

      velocity =
          (velocity - (normal * (restitution * 2 * velocity.dot(normal)))) *
              0.98;

      if (velocity.length < 20.0) {
        velocity = velocity.normalized() * 20.0;
      }

      final randomBounce = random.nextDouble() * 5 - 2.5;
      velocity.x += randomBounce;

      final overlap = normal * 5.0;
      position += overlap;
    }
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = Color(0xffF6D303);

    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2),
      size.x / 2,
      paint,
    );
  }
}
