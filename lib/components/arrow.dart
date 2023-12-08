import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/palette.dart';

class Arrow extends Component {
  final Vector2 fromPos;
  final Vector2 toPos;
  Paint arrowPaint = BasicPalette.blue.paint();
  Arrow({
    required this.fromPos,
  }) : toPos = fromPos;

  @override
  void render(Canvas canvas) {
    canvas.drawLine(fromPos.toOffset(), toPos.toOffset(), arrowPaint);
    const scale = 5.0;
    final dir1 = toPos - Vector2(fromPos.x + toPos.x, fromPos.y);
    final dir2 = toPos - Vector2(fromPos.x, fromPos.y + toPos.y);
    canvas.drawLine(
      (dir1.clone()..scaleTo(scale)).toOffset(),
      toPos.toOffset(),
      arrowPaint,
    );
    canvas.drawLine(
      (dir2.clone()..scaleTo(scale)).toOffset(),
      toPos.toOffset(),
      arrowPaint,
    );
    super.render(canvas);
  }
}
