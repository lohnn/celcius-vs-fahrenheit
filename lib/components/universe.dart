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
      ),
      Planet(
        population: 100,
      ),
      Planet(
        population: 100,
      ),
      Planet(
        population: 100,
      ),
    ];

    for (final planet in planets) {
      add(planet);
    }
  }
}
