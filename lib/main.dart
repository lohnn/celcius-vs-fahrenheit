import 'dart:math';

import 'package:celsius_vs_fahrenheit/components/universe.dart';
import 'package:celsius_vs_fahrenheit/handler/audio_handler.dart';
import 'package:celsius_vs_fahrenheit/screens/end_screen.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      home: GameWidget<MyGame>(
        game: MyGame(),
        overlayBuilderMap: {
          'won': (_, game) => EndScreen(
                didWin: true,
                onRetryPressed: game.restart,
              ),
          'lost': (_, game) => EndScreen(
                didWin: false,
                onRetryPressed: game.restart,
              ),
        },
      ),
    ),
  );
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

  void restart() {
    world = Universe();
    overlays.clear();
  }

  @override
  Future<void> update(double dt) async {
    super.update(dt);
    if (winningState && !won) {
      await audioHandler.stopBackgroundMusic();
      await audioHandler.playWinning();
      won = true;

      overlays.add('won');
    }
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
