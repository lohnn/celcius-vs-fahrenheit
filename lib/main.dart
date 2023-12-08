import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:gj23/components/universe.dart';

void main() {
  runApp(GameWidget(game: MyGame()));
}

class MyGame extends FlameGame with TapCallbacks {
  @override
  Future<void> onLoad() async {
    world = Universe();
    return super.onLoad();
  }
}
