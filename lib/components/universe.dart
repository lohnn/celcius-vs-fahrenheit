import 'package:flame/components.dart';
import 'package:gj23/components/planet.dart';

class Universe extends World {
  final planets = <Planet>[];

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await add(Planet());
  }
}
