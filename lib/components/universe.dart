import 'dart:math';

import 'package:celsius_vs_fahrenheit/components/arrow.dart';
import 'package:celsius_vs_fahrenheit/components/end_turn_button.dart';
import 'package:celsius_vs_fahrenheit/components/planet.dart';
import 'package:celsius_vs_fahrenheit/extension/map_extension.dart';
import 'package:celsius_vs_fahrenheit/main.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

class Universe extends World with DragCallbacks, HasGameRef<MyGame> {
  Iterable<Planet> get planets => children.query<Planet>();

  ({Arrow arrow, FirePlanet fromPlanet})? currentArrow;
  Planet? currentToPlanet;

  int waitFor = 0;

  void clearDrag() {
    currentArrow = null;
    currentToPlanet = null;
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    if (currentArrow != null) {
      return;
    }
    if (componentsAtPoint(event.localPosition)
            .whereType<FirePlanet>()
            .firstOrNull
        case final fromPlanet?) {
      final arrow = Arrow(fromPos: fromPlanet.center);
      currentArrow = (
        arrow: arrow,
        fromPlanet: fromPlanet,
      );
      add(arrow);
    }
  }

  final _arrowMaxLength = 150;

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    if (currentArrow case final currentArrow?) {
      final intendedEndPosition =
          event.localEndPosition - currentArrow.arrow.fromPos;
      if (componentsAtPoint(event.localEndPosition)
              .whereType<Planet>()
              .firstOrNull
          case final toPlanet?
          when currentArrow.fromPlanet != toPlanet &&
              intendedEndPosition.length < _arrowMaxLength) {
        currentToPlanet = toPlanet;
        currentArrow.arrow.toPos.setFrom(toPlanet.center);
      } else {
        currentToPlanet = null;
        final squishValue = intendedEndPosition.length - _arrowMaxLength;
        final clampedArrowEndPosition = intendedEndPosition
          ..clampLength(0, _arrowMaxLength + squishValue * 0.3);
        currentArrow.arrow.toPos.setFrom(
          currentArrow.arrow.fromPos + clampedArrowEndPosition,
        );
      }
    }
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);

    if (currentArrow case final currentArrow?) {
      if (currentToPlanet case final currentToPlanet?) {
        currentArrow.fromPlanet.startTargeting(
          currentToPlanet,
          currentArrow.arrow,
        );
      } else {
        currentArrow.arrow.removeFromParent();
      }
    }
    clearDrag();
  }

  static const _basePlanetStartPopulation = 100;
  static const _centrePlanetStartPopulation = 120;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    final neutralCoordinates = <(double, double, int)>[
      (80, 120, 50),
      (150, 100, 75),
      (300, 120, 100),
    ];

    [
      FirePlanet(
        population: _basePlanetStartPopulation,
        position: Vector2(150, 150),
      ),
      NeutralPlanet(
        population: _centrePlanetStartPopulation,
        position: Vector2(0, 0),
      ),
      for (final coordinate in neutralCoordinates)
        NeutralPlanet(
          population: coordinate.$3,
          position: Vector2(coordinate.$1 - 200, coordinate.$2 - 200),
        ),
      for (final coordinate in neutralCoordinates)
        NeutralPlanet(
          population: coordinate.$3,
          position: Vector2(
            200 - coordinate.$1,
            200 - coordinate.$2,
          ),
        ),
      IcePlanet(
        population: _basePlanetStartPopulation,
        position: Vector2(-150, -150),
      ),
    ].forEach(add);

    addAll([
      RectangleComponent(
        position: Vector2(-200, 200),
        anchor: Anchor.bottomLeft,
        size: Vector2(120, 66),
        paint: Paint()..color = Colors.black.withOpacity(1.0),
      ),
      ButtonComponent(
        button: EndTurnButton(),
        buttonDown: EndTurnButton(isDown: true),
        onPressed: triggerNextTurn,
        size: Vector2(120, 50),
        position: Vector2(-190, 190),
        anchor: Anchor.bottomLeft,
      ),
    ]);

    for (var i = 0; i < 100; i++) {
      _stars[Offset(
        400 * _starsRandom.nextDouble() - 200,
        400 * _starsRandom.nextDouble() - 200,
      )] = 1.5 * _starsRandom.nextDouble();
    }
  }

  final _stars = <Offset, double>{};
  final _starsRandom = Random();
  final _starsPaint = BasicPalette.white.paint();

  @override
  void render(Canvas canvas) {
    for (final (offset, size) in _stars.records) {
      canvas.drawCircle(
        offset,
        size,
        _starsPaint,
      );
    }

    super.render(canvas);
  }

  void termosArrived() {
    waitFor = waitFor - 1;
    if (waitFor == 0) {
      handlePlanets();
    }
  }

  void checkGameConditions() {
    final isPlanetsEmpty = planets.whereType<IcePlanet>().isEmpty;
    final firePlanetsEmpty = planets.whereType<FirePlanet>().isEmpty;

    if (isPlanetsEmpty) {
      gameRef.setEndCondition(didWin: true);
    } else if (firePlanetsEmpty) {
      gameRef.setEndCondition(didWin: false);
    } else if (isPlanetsEmpty && firePlanetsEmpty) {
      gameRef.setEndCondition(didWin: null);
    }
  }

  void setIceMoves() {
    final withinRange = <Planet>[];
    final allTargets = <Planet, List<Planet>>{};
    final actingPlanets = <Planet>[];

    bool reinforce(Planet currentPlanet, List<Planet> possibleTargets) {
      var allFriends = true;
      for (final otherPlanet in possibleTargets) {
        if (otherPlanet is! IcePlanet) {
          allFriends = false;
          break;
        }
      }
      if (currentPlanet.population > 300 && allFriends) {
        for (final otherPlanet in possibleTargets) {
          Arrow arrow = Arrow(fromPos: currentPlanet.center);
          arrow.toPos = otherPlanet.center;
          currentPlanet.targetPlanets[otherPlanet] = arrow;
        }
        return true;
      }
      return false;
    }

    for (final planet in planets) {
      if (planet is IcePlanet) {
        for (final otherPlanet in planets) {
          if (otherPlanet != planet &&
              (planet.position - otherPlanet.position).length < 150) {
            withinRange.add(otherPlanet);
            if (otherPlanet is! IcePlanet) {
              allTargets.update(
                otherPlanet,
                (value) => value..add(planet),
                ifAbsent: () => [planet],
              );
            }
          }
        }
        if (!reinforce(planet, withinRange)) {
          for (final target in withinRange) {
            if (target.population < planet.population / 2 &&
                target is! IcePlanet) {
              planet.targetPlanets[target] = Arrow(fromPos: Vector2(0, 0));
              actingPlanets.add(planet);
              break;
            }
          }
        }
      }
    }
    for (final (target, attackers) in allTargets.records) {
      final targetPop = target.population;
      var possibleForce = 0;
      final fallang = <Planet>[];
      for (final attacker in attackers) {
        if (!actingPlanets.contains(attacker)) {
          possibleForce += (attacker.population / 1.5).round();
          fallang.add(attacker);
        }
        if (possibleForce / 2 > targetPop) {
          for (final attackingPlanet in fallang) {
            attackingPlanet.targetPlanets[target] =
                Arrow(fromPos: Vector2(0, 0));
            actingPlanets.add(attackingPlanet);
          }
        }
      }
    }
  }

  void triggerNextTurn() {
    setIceMoves();
    for (final planet in planets) {
      planet.settleArrows();
    }
    print("waiting for $waitFor");
    if (waitFor == 0) {
      handlePlanets();
    }
  }

  void handlePlanets() {
    for (final planet in planets) {
      const threshold = 5;
      const growthRate = 1.25;

      final Type invadorType;
      Planet? newP = null;

      var invadorForce = planet.firePopulation - planet.icePopulation;
      if (invadorForce > 0) {
        invadorType = FirePlanet;
      } else {
        invadorType = IcePlanet;
      }
      invadorForce = invadorForce.abs();
      if (planet.runtimeType == NeutralPlanet) {
        final newPopulation = planet.population - invadorForce;
        if (newPopulation < threshold) {
          newP = newPlanet(invadorType, planet, newPopulation.abs());
        } else {
          planet.population = newPopulation;
        }
      } else if (planet.runtimeType != invadorType) {
        final newPopulation = planet.population - invadorForce;
        if (newPopulation < 0) {
          newP = newPlanet(invadorType, planet, newPopulation.abs());
        } else {
          planet.population = newPopulation;
        }
      } else if (planet.runtimeType == invadorType) {
        planet.population = planet.population + invadorForce;
      }

      if (planet.population < threshold) {
        newP = newPlanet(NeutralPlanet, planet, planet.population);
      }

      if (newP != null) {
        planet.explode(() {
          planet.removeFromParent();
          add(newP!);
        });
      }

      if (planet.runtimeType != NeutralPlanet) {
        planet.population = (planet.population * growthRate).round();
      }
      planet.targetPlanets.clear();
      planet.icePopulation = 0;
      planet.firePopulation = 0;
      checkGameConditions();
    }
  }

  Planet newPlanet(Type planetType, Planet old, int population0) {
    int population = max(population0, 15);
    Vector2 position = old.position;

    return switch (planetType) {
      FirePlanet => FirePlanet(
          population: population,
          position: position,
        ),
      IcePlanet => IcePlanet(
          population: population,
          position: position,
        ),
      _ => NeutralPlanet(
          population: population,
          position: position,
        ),
    };
  }
}
