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

    planets = [
      FirePlanet(
        population: 100,
        position: Vector2(100, 200),
      ),
      NeutralPlanet(
        population: 100,
        position: Vector2(-100, 200),
      ),
      NeutralPlanet(
        population: 100,
        position: Vector2(200, 100),
      ),
      IcePlanet(
        population: 100,
        position: Vector2(-200, 100),
      ),
    ];

    for (final planet in planets) {
      add(planet);
    }
  }
}
