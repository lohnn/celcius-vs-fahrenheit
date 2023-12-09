import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/palette.dart';

class EndTurnButton extends PositionComponent {
  final bool isDown;

  EndTurnButton({this.isDown = false}) : super(size: Vector2(120, 50));

  final _downPaint = const PaletteEntry(Color(0x5c93590d)).paint()
    ..strokeWidth = 2
    ..strokeJoin = StrokeJoin.round
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke;

  final _downBackgroundPaint = const PaletteEntry(Color(0x3c93590d)).paint()
    ..strokeWidth = 2
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round
    ..style = PaintingStyle.fill;

  final _upPaint = const PaletteEntry(Color(0xc7b26b0f)).paint()
    ..strokeWidth = 2
    ..strokeJoin = StrokeJoin.round
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke;

  final _upBackgroundPaint = const PaletteEntry(Color(0x5c93590d)).paint()
    ..strokeWidth = 2
    ..strokeJoin = StrokeJoin.round
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.fill;

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final paint = switch (isDown) {
      true => _downPaint,
      false => _upPaint,
    };

    final backgroundPaint = switch (isDown) {
      true => _downBackgroundPaint,
      false => _upBackgroundPaint,
    };

    final path = Path();
    path.moveTo(5, 0);

    path.lineTo(width - 5, 0);
    path.quadraticBezierTo(width - 5, 5, width, 5);
    path.lineTo(width, height - 5);
    path.quadraticBezierTo(width - 5, height - 5, width - 5, height);
    path.lineTo(5, height);
    path.quadraticBezierTo(5, height - 5, 0, height - 5);
    path.moveTo(0, height - 5);
    path.lineTo(0, 5);
    path.quadraticBezierTo(5, 5, 5, 0);

    canvas.drawPath(path, backgroundPaint);
    canvas.drawPath(path, paint);

    final hourGlassPath = Path();

    final hourGlassHeight = height - 10;
    final hourGlassLeft = width / 2 - hourGlassHeight / 3;
    final hourGlassRight = width / 2 + hourGlassHeight / 3;

    hourGlassPath.moveTo(hourGlassLeft, 5);
    hourGlassPath.lineTo(hourGlassRight, 5);
    hourGlassPath.lineTo(hourGlassLeft, height - 5);
    hourGlassPath.lineTo(hourGlassRight, height - 5);
    hourGlassPath.lineTo(hourGlassLeft, 5);

    canvas.drawPath(hourGlassPath, paint);

    final hourGlassFillPath = Path();

    switch (isDown) {
      case true:
        hourGlassFillPath.moveTo(hourGlassLeft, height - 5);
        hourGlassFillPath.lineTo(hourGlassRight, height - 5);
        hourGlassFillPath.lineTo(width / 2, height / 2);
        hourGlassFillPath.lineTo(width / 2, height / 2);
        hourGlassFillPath.lineTo(hourGlassLeft, height - 5);
      case false:
        hourGlassFillPath.moveTo(hourGlassLeft, 5);
        hourGlassFillPath.lineTo(hourGlassRight, 5);
        hourGlassFillPath.lineTo(width / 2, height / 2);
        hourGlassFillPath.lineTo(width / 2, height / 2);
        hourGlassFillPath.lineTo(hourGlassLeft, 5);
    }
    canvas.drawPath(hourGlassFillPath, backgroundPaint);

    // canvas.drawRect(
    //   Rect.fromLTRB(
    //     width / 2 - hourGlassHeight / 3,
    //     5,
    //     width / 2 + hourGlassHeight / 3,
    //     height - 5,
    //   ),
    //   paint,
    // );
  }
}
