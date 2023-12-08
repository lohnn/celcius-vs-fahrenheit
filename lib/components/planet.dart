import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/rendering.dart';
import 'package:gj23/main.dart';

enum Possession {
  none,
  fire,
  ice,
  ;

  static final _paint = BasicPalette.white.paint();
  static final _icePaint = BasicPalette.blue.paint();
  static final _firePaint = BasicPalette.red.paint();

  Paint get paint => switch (this) {
        none => _paint,
        fire => _firePaint,
        ice => _icePaint,
      };
}

enum AnimationState { idle, shooting, growing, hit, dying, won }

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
  // TODO: implement paint
  Paint get paint => BasicPalette.red.paint();
}

class IcePlanet extends Planet {
  IcePlanet({
    required super.population,
    super.position,
  });

  @override
  // TODO: implement paint
  Paint get paint => BasicPalette.blue.paint();
}

class NeutralPlanet extends Planet {
  NeutralPlanet({
    required super.population,
    super.position,
  });

  @override
  // TODO: implement paint
  Paint get paint => BasicPalette.gray.paint();
}
