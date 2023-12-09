import 'dart:math';

import 'package:celsius_vs_fahrenheit/components/arrow.dart';
import 'package:celsius_vs_fahrenheit/components/planet.dart';
import 'package:celsius_vs_fahrenheit/extension/map_extension.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

class Universe extends World with DragCallbacks {
  Iterable<Planet> get planets => children.query<Planet>();

  ({Arrow arrow, FirePlanet fromPlanet})? currentArrow;
  Planet? currentToPlanet;

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

    final buttonSpriteSheet = SpriteSheet(
      image: await Flame.images.load('EndTurnButton-Sheet.png'),
      srcSize: Vector2(120, 66),
    );

    addAll([
      RectangleComponent(
        position: Vector2(-200, 200),
        anchor: Anchor.bottomLeft,
        size: Vector2(120, 66),
        paint: Paint()..color = Colors.black.withOpacity(1.0),
      ),
      SpriteButtonComponent(
        button: buttonSpriteSheet.getSpriteById(0),
        buttonDown: buttonSpriteSheet.getSpriteById(1),
        onPressed: triggerNextTurn,
        size: Vector2(120, 66),
        position: Vector2(-200, 200),
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

  void triggerNextTurn() {
    const threshold = 5;
    const growthRate = 1.25;
    final newPlanets = <(Planet, Planet)>[];

    for (final planet in planets) {
      planet.settleArrows();
    }

    for (final planet in planets) {
      final Type invadorType;
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
          newPlanets.add(
              (planet, newPlanet(invadorType, planet, newPopulation.abs())));
        } else {
          planet.population = newPopulation;
        }
      } else if (planet.runtimeType != invadorType) {
        final newPopulation = planet.population - invadorForce;
        if (newPopulation < 0) {
          newPlanets.add(
              (planet, newPlanet(invadorType, planet, newPopulation.abs())));
        } else {
          planet.population = newPopulation;
        }
      } else if (planet.runtimeType == invadorType) {
        planet.population = planet.population + invadorForce;
      }
    }

    for (final planet in planets) {
      if (planet.population < threshold) {
        newPlanets
            .add((planet, newPlanet(NeutralPlanet, planet, planet.population)));
      }
    }
    for (final (old, newP) in newPlanets) {
      old.removeFromParent();
      add(newP);
    }

    for (final planet in planets) {
      if (planet.runtimeType != NeutralPlanet) {
        planet.population = (planet.population * growthRate).round();
      }
      planet.targetPlanets.clear();
      planet.icePopulation = 0;
      planet.firePopulation = 0;
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
