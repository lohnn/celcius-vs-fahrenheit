import 'package:flame/components.dart';

class Arrow extends PositionComponent {
  Vector2 fromPos;
  Vector2 toPos;

  Arrow({
    required this.fromPos,
  }) : toPos = fromPos;
}
