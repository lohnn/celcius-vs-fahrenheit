import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/rendering.dart';
import 'package:gj23/main.dart';

enum AnimationState {
  idle,
  shooting,
  growing,
  hit,
  dying,
  won,
  ;
}

sealed class Planet extends PositionComponent with HasGameRef<MyGame> {
  int population;

  Paint get paint;

  Planet({
    required this.population,
    super.position,
  }) : super(anchor: Anchor.center);

  @override
  void render(Canvas c) {
    c.drawCircle(
      Offset.zero,
      sqrt(population),
      paint,
    );
  }

  @override
  void update(double dt) {}

  @override
  Future<void> onLoad() async {
    super.onLoad();
  }
}

class FirePlanet extends Planet {
  FirePlanet({
    required super.population,
    super.position,
  });

  @override
  Paint get paint => BasicPalette.red.paint();
}

class IcePlanet extends Planet {
  IcePlanet({
    required super.population,
    super.position,
  });

  @override
  Paint get paint => BasicPalette.blue.paint();
}

class NeutralPlanet extends Planet {
  NeutralPlanet({
    required super.population,
    super.position,
  });

  @override
  Paint get paint => BasicPalette.gray.paint();
}
