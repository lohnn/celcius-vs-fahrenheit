import 'package:flame/components.dart';
import 'package:gj23/components/planet.dart';

class Universe extends World {
  late final List<Planet> planets;

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
