import 'package:celsius_vs_fahrenheit/components/universe.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'handler/audio_handler.dart';

void main() {
  runApp(GameWidget(game: MyGame()));
}

class MyGame extends FlameGame with TapCallbacks {
  MyGame()
      : super(
          camera: CameraComponent.withFixedResolution(
            width: 400,
            height: 400,
          ),
        );

  final audioHandler = AudioHandler();

  @override
  Future<void> onLoad() async {
    await audioHandler.init();
    world = Universe();
    return super.onLoad();
  }

  @override
  void onTapUp(TapUpEvent event) {
    audioHandler.playBackgroundMusic();
    super.onTapUp(event);
  }
}
