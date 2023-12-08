import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:gj23/components/arrow.dart';
import 'package:gj23/components/planet.dart';

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
    if (currentArrow != null) return;
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
        // TODO: Hand over the arrow to the planet
        print(
          'Dropping ship: ${currentArrow.fromPlanet} $currentToPlanet',
        );
      } else {
        currentArrow.arrow.removeFromParent();
      }
    }
    clearDrag();
  }

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
        population: 100,
        position: Vector2(150, 150),
      ),
      NeutralPlanet(
        population: 120,
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
        population: 100,
        position: Vector2(-150, -150),
      ),
    ];

    for (final planet in planets) {
      add(planet);
    }
  }
}
