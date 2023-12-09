import 'dart:math';

import 'package:flame/components.dart';
import 'package:gj23/components/arrow.dart';
import 'package:gj23/components/universe.dart';
import 'package:gj23/extension/map_extension.dart';
import 'package:gj23/main.dart';

enum AnimationState {
  idle,
//  shooting,
//  growing,
//  hit,
//  dying,
//  won,
  ;
}

sealed class Planet extends SpriteAnimationGroupComponent<AnimationState>
    with HasWorldReference<Universe>, HasGameReference<MyGame> {
  int _population;

  int get population => _population;

  set population(int newValue) {
    final newSize = sqrt(newValue);
    size = Vector2(newSize, newSize) * 3;
    _population = population;
  }

  final roundArrows = <Arrow>[];

  Map<AnimationState, String> get animationImages;

  Planet({
    required int population,
    super.position,
  })  : _population = population,
        super(anchor: Anchor.center, current: AnimationState.idle);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    final newSize = sqrt(population);
    size = Vector2(newSize, newSize) * 3;
    animations = {
      for (final (state, asset) in animationImages.records)
        state: await game.loadSpriteAnimation(
          asset,
          SpriteAnimationData.sequenced(
            amount: 4,
            textureSize: Vector2.all(32),
            stepTime: 0.15,
          ),
        ),
    };
  }
}

interface class FightingPlanets {}

class FirePlanet extends Planet implements FightingPlanets {
  FirePlanet({
    required super.population,
    super.position,
  });

  @override
  Map<AnimationState, String> get animationImages => {
        AnimationState.idle: 'FirePlanet_idle-Sheet.png',
      };
}

class IcePlanet extends Planet implements FightingPlanets {
  IcePlanet({
    required super.population,
    super.position,
  });

  @override
  Map<AnimationState, String> get animationImages => {
        AnimationState.idle: 'FirePlanet_idle-Sheet.png',
      };
}

class NeutralPlanet extends Planet {
  NeutralPlanet({
    required super.population,
    super.position,
  });

  @override
  Map<AnimationState, String> get animationImages => {
        AnimationState.idle: 'FirePlanet_idle-Sheet.png',
      };
}
