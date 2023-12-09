import 'package:celsius_vs_fahrenheit/components/universe.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(GameWidget(game: MyGame()));
}

class MyGame extends FlameGame {
  MyGame()
      : super(
          camera: CameraComponent.withFixedResolution(
            width: 400,
            height: 400,
          ),
        );

  @override
  Future<void> onLoad() async {
    world = Universe();
    return super.onLoad();
  }
}
