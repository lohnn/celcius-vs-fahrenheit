import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/rendering.dart';
import 'package:gj23/components/arrow.dart';
import 'package:gj23/components/universe.dart';

enum AnimationState {
  idle,
  shooting,
  growing,
  hit,
  dying,
  won,
  ;
}

sealed class Planet extends PositionComponent with HasWorldReference<Universe> {
  int _population;

  int get population => _population;

  set population(int newValue) {
    final newSize = sqrt(newValue);
    size = Vector2(newSize, newSize) * 3;
    _population = population;
  }

  Paint get paint;

  final roundArrows = <Arrow>[];

  Planet({
    required int population,
    super.position,
  })  : _population = population,
        super(anchor: Anchor.center);

  @override
  void render(Canvas c) {
    c.drawCircle(
      size.toOffset() / 2,
      size.x / 2,
      paint,
    );
  }

  @override
  void update(double dt) {}

  @override
  Future<void> onLoad() async {
    super.onLoad();
    final newSize = sqrt(population);
    size = Vector2(newSize, newSize) * 3;
  }
}

interface class FightingPlanets {}

class FirePlanet extends Planet implements FightingPlanets {
  FirePlanet({
    required super.population,
    super.position,
  });

  @override
  Paint get paint => BasicPalette.red.paint();
}

class IcePlanet extends Planet implements FightingPlanets {
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
