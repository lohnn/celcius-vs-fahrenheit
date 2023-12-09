import 'package:celsius_vs_fahrenheit/main.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class VictoryScreen extends PositionComponent with HasGameRef<MyGame> {
  VictoryScreen({required super.size});
  @override
  Future<void>? onLoad() async {
    position = gameRef.size / 2;
    anchor = Anchor.center;

    addAll(
      [
        RectangleComponent(
          position: size / 2,
          anchor: Anchor.center,
          size: size,
          paint: Paint()..color = Colors.white.withOpacity(0.8),
        ),
        TextComponent(text: '🔥🔥🔥🔥')
          ..anchor = Anchor.topCenter
          ..position = Vector2(size.x / 2, 35),
        TextComponent(
          text: '🤔🤔',
          anchor: Anchor.bottomCenter,
          position: Vector2(size.x / 2, size.y - 70),
        ),
      ],
    );
    return super.onLoad();
  }
}
