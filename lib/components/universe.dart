import 'package:celsius_vs_fahrenheit/components/arrow.dart';
import 'package:celsius_vs_fahrenheit/components/planet.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

class Universe extends World with DragCallbacks {
  late final List<Planet> planets;

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

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    if (currentArrow case final currentArrow?) {
      if (componentsAtPoint(event.localEndPosition)
              .whereType<Planet>()
              .firstOrNull
          case final toPlanet? when currentArrow.fromPlanet != toPlanet) {
        currentToPlanet = toPlanet;
        currentArrow.arrow.toPos.setFrom(toPlanet.center);
      } else {
        currentToPlanet = null;
        currentArrow.arrow.toPos.setFrom(event.localEndPosition);
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

    planets = [
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
    ];

    for (final planet in planets) {
      add(planet);
    }

    addAll([
      RectangleComponent(
        position: Vector2(-200, 200),
        anchor: Anchor.bottomLeft,
        size: Vector2(120, 66),
        paint: Paint()..color = Colors.black.withOpacity(1.0),
      ),
      SpriteButtonComponent(
        button: await Sprite.load('EndTurnbuttonup.png'),
        buttonDown: await Sprite.load('EndTurnbuttondown.png'),
        onPressed: () {},
        size: Vector2(120, 66),
        position: Vector2(-200, 200),
        anchor: Anchor.bottomLeft,
      ),
    ]);
  }
}
