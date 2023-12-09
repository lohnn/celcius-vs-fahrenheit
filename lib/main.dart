import 'package:celsius_vs_fahrenheit/components/universe.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'components/victory_screen.dart';
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
  bool loosingState = false;
  bool winningState = false;
  bool lost = false;
  bool won = false;

  @override
  Future<void> update(double dt) async {
    super.update(dt);
    if (winningState && !won) {
      await audioHandler.stopBackgroundMusic();
      await audioHandler.playWinning();
      won = true;
      add(VictoryScreen(size: Vector2(300, 300)));
    }
//    if (loosingState && !lost) {
//      await audioHandler.stopBackgroundMusic();
//      add(LoosingScreen());
//      lost = true;
    super.update(dt);
  }

  @override
  Future<void> onLoad() async {
    await audioHandler.init();
    world = Universe();
    return super.onLoad();
  }

  @override
  void onTapUp(TapUpEvent event) {
    if (!audioHandler.isPlaying()) {
      audioHandler.playBackgroundMusic();
    }
    super.onTapUp(event);
  }
}
