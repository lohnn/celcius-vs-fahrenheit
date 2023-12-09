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

  void restart() {
    world = Universe();
    overlays.clear();
  }

  Future<void> setEndCondition({required bool didWin}) async {
    await audioHandler.stopBackgroundMusic();
    await audioHandler.playWinning();

    overlays.add(
      switch (didWin) {
        true => 'won',
        false => 'lost',
      },
    );
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
