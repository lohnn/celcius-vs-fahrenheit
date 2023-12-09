import 'dart:math';
import 'dart:ui';

import 'package:celsius_vs_fahrenheit/components/arrow.dart';
import 'package:celsius_vs_fahrenheit/extension/map_extension.dart';
import 'package:celsius_vs_fahrenheit/main.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';

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
  bool get debugMode => false;

  @override
  void renderDebugMode(Canvas canvas) {
    super.renderDebugMode(canvas);
    debugTextPaint.render(
      canvas,
      'p: $population',
      Vector2(-10, 15 ),
    );
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    population = population;

    final SpriteAnimation idle = await game.loadSpriteAnimation(
      animationImages[AnimationState.idle]!,
      SpriteAnimationData.sequenced(
        amount: 4,
        textureSize: Vector2.all(32),
        stepTime: 0.3,
      ),
    );
    final SpriteAnimation dying = await game.loadSpriteAnimation(
      animationImages[AnimationState.dying]!,
      SpriteAnimationData.sequenced(
          amount: 5, textureSize: Vector2.all(32), stepTime: 1.5, loop: false),
    );
    animations = {AnimationState.dying: dying, AnimationState.idle: idle};
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
        AnimationState.dying: 'FirePlanet-explosion.png',
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
        AnimationState.dying: 'FirePlanet-explosion.png',
        AnimationState.idle: 'NeutralPlanet_idle-Sheet.png',
      };
}
