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

class Planet extends PositionComponent with HasGameRef<MyGame> {
  int population;
  Possession possession;

  Planet({
    required this.population,
    this.possession = Possession.none,
    super.position,
  }) : super(anchor: Anchor.center);

  @override
  void render(Canvas c) {
    c.drawCircle(
      Offset.zero,
      sqrt(population),
      possession.paint,
    );
  }

  @override
  void update(double dt) {}
}
