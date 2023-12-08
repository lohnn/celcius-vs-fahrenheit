import 'package:flame/components.dart';
import 'package:gj23/components/planet.dart';

class Universe extends World {
  late final List<Planet> planets;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    planets = [
      Planet(
        population: 100,
        position: Vector2(100, 200),
        possession: Possession.fire,
      ),
      Planet(
        population: 100,
        position: Vector2(-100, 200),
      ),
      Planet(
        population: 100,
        position: Vector2(200, 100),
      ),
      Planet(
        population: 100,
        position: Vector2(-200, 100),
        possession: Possession.ice,
      ),
    ];

    for (final planet in planets) {
      add(planet);
    }
  }
}
