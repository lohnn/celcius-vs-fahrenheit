import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:gj23/components/arrow.dart';
import 'package:gj23/components/planet.dart';

class Universe extends World with DragCallbacks {
  late final List<Planet> planets;

  ({Arrow arrow, FirePlanet fromPlanet})? currentArrow;

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    if (currentArrow != null) return;
    if (componentsAtPoint(event.canvasPosition)
            .whereType<FirePlanet>()
            .firstOrNull
        case final fromPlanet?) {
      final arrow = Arrow(fromPos: event.canvasPosition);
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
    currentArrow?.arrow.toPos.setFrom(event.localEndPosition);

    final toWorld = componentsAtPoint(event.localEndPosition)
        .whereType<Planet>()
        .firstOrNull;

    print(toWorld);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    currentArrow?.arrow.removeFromParent();
    currentArrow = null;
    // TODO: Check overlaps
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
