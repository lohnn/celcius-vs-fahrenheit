import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/palette.dart';
// ignore: implementation_imports
import 'package:flame/src/rendering/paint_decorator.dart';

enum ArrowPaint {
  back,
  front,
}

class Arrow extends Component with HasPaint<ArrowPaint>, HasDecorator {
  final Vector2 fromPos;
  Vector2 toPos;
  Paint arrowPaint = BasicPalette.blue.paint();

  Arrow({
    required this.fromPos,
  }) : toPos = fromPos.clone();

  @override
  Future<void> onLoad() async {
    decorator = PaintDecorator.blur(.8);
    final front = BasicPalette.yellow.paint()..strokeWidth = 2;
    front.color = front.color.withOpacity(1);
    final back = BasicPalette.red.paint()
      ..darken(0.7)
      ..strokeWidth = 6;
    back.color = back.color.withOpacity(0.9);
    setPaint(ArrowPaint.front, front);
    setPaint(ArrowPaint.back, back);
  }

  @override
  void render(Canvas canvas) {
    for (final currentPaintType in ArrowPaint.values) {
      final arrowPaint = getPaint(currentPaintType);
      canvas.drawLine(fromPos.toOffset(), toPos.toOffset(), arrowPaint);
      final delta = toPos - fromPos;
      final scale = log(delta.length) * 4;
      final unitvector = delta.normalized();
      final rotationMat1 = Matrix2.rotation(45 * (pi / 180));
      final rotationMat2 = Matrix2.rotation(-45 * (pi / 180));

      final rotated1 = rotationMat1.transformed(unitvector);
      final point1 = rotated1.scaled(scale);

      final rotated2 = rotationMat2.transformed(unitvector);
      final point2 = rotated2.scaled(scale);
      canvas.drawLine(
        toPos.toOffset() - point1.toOffset(),
        toPos.toOffset(),
        arrowPaint,
      );
      canvas.drawLine(
        toPos.toOffset() - point2.toOffset(),
        toPos.toOffset(),
        arrowPaint,
      );
    }
    super.render(canvas);
  }
}
