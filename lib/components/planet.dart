import 'package:celsius_vs_fahrenheit/components/arrow.dart';
import 'package:celsius_vs_fahrenheit/extension/map_extension.dart';
import 'package:celsius_vs_fahrenheit/main.dart';
import 'package:flame/components.dart';

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
    with HasGameReference<MyGame> {
  int _population;

  int get population => _population;
  int fire_population;
  int ice_population;

  set population(int newValue) {
    size = Vector2(newValue.toDouble(), newValue.toDouble()) * 0.5;
    _population = population;
  }

  final targetPlanets = <Planet, Arrow>{};

  Map<AnimationState, String> get animationImages;

  Planet({
    required int population,
    required super.position,
  })  : _population = population,
        fire_population = 0,
        ice_population = 0,
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
            stepTime: 0.15,
          ),
        ),
    };
  }
  
  void settleArrows() {}

}

interface class FightingPlanets {}

class FirePlanet extends Planet implements FightingPlanets {
  FirePlanet({
    required super.population,
    super.position,
  });

  @override
  void settleArrows() {
    int n_planets = targetPlanets.length;
    int settlerForce = (population / (n_planets+1)).round();
    for (final (planet, arrow) in targetPlanets.records) {
      planet.fire_population = planet.fire_population + settlerForce;
    }

  }

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
  void settleArrows() {
    int n_planets = targetPlanets.length;
    int settlerForce = (population / (n_planets+1)).round();
    for (final (planet, arrow) in targetPlanets.records) {
      planet.ice_population = planet.ice_population + settlerForce;
    }

  }


  @override
  Map<AnimationState, String> get animationImages => {
        AnimationState.idle: 'IcePlanet_idle-Sheet.png',
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
