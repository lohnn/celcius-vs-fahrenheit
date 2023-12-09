import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';

class Termos extends SpriteComponent {
  final Vector2 fromPos;
  final Vector2 toPos;
  final void Function() onTravelComplete;

  Termos({
    required this.fromPos,
    required this.toPos,
    required this.onTravelComplete,
  });

  

  @override
  Future<void> onLoad() async {
    super.onLoad();
    final image = await Flame.images.load('Termos-grön.png');
    sprite = Sprite(image);
    size = Vector2(8, 8);
    position = fromPos;
    lookAt(toPos);
    angle = angle + pi/2;
    add(MoveToEffect(
      toPos,
      EffectController(duration: 2),
      onComplete: () {
        removeFromParent();
        onTravelComplete();
      },
    ),);
  }

  

}