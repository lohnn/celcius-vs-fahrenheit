import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/palette.dart';
import 'package:gj23/main.dart';

class Planet extends PositionComponent with HasGameRef<MyGame> {
  static final _paint = BasicPalette.white.paint();
  int population;

  Planet({
    required this.population,
    super.position,
  }) : super(anchor: Anchor.center);

  @override
  void render(Canvas c) {
    c.drawCircle(Offset.zero, sqrt(population), _paint);
  }

  @override
  void update(double dt) {}
}
