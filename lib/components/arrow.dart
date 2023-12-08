import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/palette.dart';

class Arrow extends Component {
  final Vector2 fromPos;
  final Vector2 toPos;
  Paint arrowPaint = BasicPalette.blue.paint();
  Arrow({
    required this.fromPos,
  }) : toPos = fromPos.clone();

  @override
  void render(Canvas canvas) {
    canvas.drawLine(fromPos.toOffset(), toPos.toOffset(), arrowPaint);
    final delta = toPos - fromPos;
    final scale = log(delta.length) * 4;
    final unitvector = delta.normalized();
    Matrix2 rotationMat1 = Matrix2.rotation(45 * (pi / 180));
    Matrix2 rotationMat2 = Matrix2.rotation(-45 * (pi / 180));

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
    super.render(canvas);
  }
}
