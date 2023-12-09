import 'dart:math';

import 'package:celsius_vs_fahrenheit/components/arrow.dart';
import 'package:celsius_vs_fahrenheit/extension/map_extension.dart';
import 'package:celsius_vs_fahrenheit/main.dart';
import 'package:flame/components.dart';

enum AnimationState {
  idle,
//  shooting,
//  growing,
//  hit,
  dying,
  birthing,
  ;
}

sealed class Planet extends SpriteAnimationGroupComponent<AnimationState>
    with HasGameReference<MyGame> {
  int _population;

  int get population => _population;
  int firePopulation;
  int icePopulation;

  set population(int newValue) {
    final newValueClamp = min(newValue, 500);
    final radius = sqrt(newValueClamp / pi);
    size = Vector2(radius, radius) * 7;
    _population = newValueClamp;
  }

  final targetPlanets = <Planet, Arrow>{};

  Map<AnimationState, String> get animationImages;

  Planet({
    required int population,
    required super.position,
  })  : _population = population,
        firePopulation = 0,
        icePopulation = 0,
        super(anchor: Anchor.center, current: AnimationState.idle);

  void startTargeting(Planet targetPlanet, Arrow arrow) {
    if (targetPlanets.containsKey(targetPlanet)) {
      arrow.removeFromParent();
      return;
    }

    targetPlanets[targetPlanet] = arrow;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    population = population;
    animations = {
      for (final (state, asset) in animationImages.records)
        state: await game.loadSpriteAnimation(
          asset,
          SpriteAnimationData.sequenced(
            amount: 4,
            textureSize: Vector2.all(32),
<<<<<<< Updated upstream
            stepTime: 0.15,
            loop: state != AnimationState.dying,
=======
            stepTime: 0.3,
>>>>>>> Stashed changes
          ),
        ),
    };
  }

  void settleArrows() {}

  void explode(void Function() addPlanet) {
    current = AnimationState.dying;
    animationTicker?.onComplete = addPlanet;
  }
}

interface class FightingPlanets {}

class FirePlanet extends Planet implements FightingPlanets {
  FirePlanet({
    required super.population,
    super.position,
  });

  @override
  void settleArrows() {
    final nPlanets = targetPlanets.length;
    final settlerForce = (population / (nPlanets + 1)).round();
    for (final (planet, arrow) in targetPlanets.records) {
      planet.firePopulation = planet.firePopulation + settlerForce;
      arrow.removeFromParent();
    }
    population = settlerForce;
  }

  @override
  Map<AnimationState, String> get animationImages => {
        AnimationState.idle: 'FirePlanet_idle-Sheet.png',
        AnimationState.dying: 'FirePlanet-explosion.png',
      };
}

class IcePlanet extends Planet implements FightingPlanets {
  IcePlanet({
    required super.population,
    super.position,
  });

  @override
  void settleArrows() {
    final nPlanets = targetPlanets.length;
    final settlerForce = (population / (nPlanets + 1)).round();
    for (final (planet, arrow) in targetPlanets.records) {
      planet.icePopulation = planet.icePopulation + settlerForce;
    }
    population = settlerForce;
  }

  @override
  Map<AnimationState, String> get animationImages => {
        AnimationState.idle: 'IcePlanet_idle-Sheet.png',
        AnimationState.birthing: 'IcePlanet_transform-Sheet.png',
      };
}

class NeutralPlanet extends Planet {
  NeutralPlanet({
    required super.population,
    super.position,
  });

  @override
  Map<AnimationState, String> get animationImages => {
        AnimationState.idle: 'NeutralPlanet_idle-Sheet.png',
      };
}
