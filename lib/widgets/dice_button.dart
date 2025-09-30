import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/dice.dart';

class DiceButton extends StatelessWidget {
  final DiceType diceType;
  final bool isLoading;
  final VoidCallback onPressed;

  const DiceButton({
    super.key,
    required this.diceType,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading ? null : onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _getDiceColor(diceType).withOpacity(0.9),
                _getDiceColor(diceType),
                _getDiceColor(diceType).withOpacity(0.7),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: _getDiceColor(diceType).withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isLoading)
                  const SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Colors.white,
                    ),
                  )
                else ...[
                  Expanded(
                    child: Center(
                      child: Transform(
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateX(-0.2)
                          ..rotateY(0.15),
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: CustomPaint(
                            painter: DicePainter(diceType),
                            size: const Size(50, 50),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      diceType.displayName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            offset: Offset(1, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getDiceColor(DiceType diceType) {
    switch (diceType) {
      case DiceType.d4:
        return const Color(0xFFE74C3C); // Red
      case DiceType.d6:
        return const Color(0xFF3498DB); // Blue
      case DiceType.d8:
        return const Color(0xFF2ECC71); // Green
      case DiceType.d10:
        return const Color(0xFFE67E22); // Orange
      case DiceType.d12:
        return const Color(0xFF9B59B6); // Purple
      case DiceType.d20:
        return const Color(0xFFFFD700); // Gold
      case DiceType.d100:
        return const Color(0xFF34495E); // Dark gray
    }
  }
}

class DicePainter extends CustomPainter {
  final DiceType diceType;
  
  DicePainter(this.diceType);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    switch (diceType) {
      case DiceType.d4:
        _paintD4(canvas, size, center);
        break;
      case DiceType.d6:
        _paintD6(canvas, size, center);
        break;
      case DiceType.d8:
        _paintD8(canvas, size, center);
        break;
      case DiceType.d10:
        _paintD10(canvas, size, center);
        break;
      case DiceType.d12:
        _paintD12(canvas, size, center);
        break;
      case DiceType.d20:
        _paintD20(canvas, size, center);
        break;
      case DiceType.d100:
        _paintD100(canvas, size, center);
        break;
    }
  }

  void _paintD4(Canvas canvas, Size size, Offset center) {
    final paint = Paint()
      ..color = const Color(0xFFE74C3C)
      ..style = PaintingStyle.fill;
    
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final radius = size.width * 0.35;
    
    // Shadow
    final shadowPath = Path();
    shadowPath.moveTo(center.dx + 2, center.dy - radius + 2);
    shadowPath.lineTo(center.dx - radius + 2, center.dy + radius * 0.5 + 2);
    shadowPath.lineTo(center.dx + radius + 2, center.dy + radius * 0.5 + 2);
    shadowPath.close();
    canvas.drawPath(shadowPath, shadowPaint);

    // Main triangle (D4)
    final path = Path();
    path.moveTo(center.dx, center.dy - radius);
    path.lineTo(center.dx - radius, center.dy + radius * 0.5);
    path.lineTo(center.dx + radius, center.dy + radius * 0.5);
    path.close();
    canvas.drawPath(path, paint);

    // Highlight
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..style = PaintingStyle.fill;
    
    final highlightPath = Path();
    highlightPath.moveTo(center.dx, center.dy - radius);
    highlightPath.lineTo(center.dx - radius * 0.3, center.dy - radius * 0.2);
    highlightPath.lineTo(center.dx + radius * 0.3, center.dy - radius * 0.2);
    highlightPath.close();
    canvas.drawPath(highlightPath, highlightPaint);

    // Number
    _drawText(canvas, '4', center, Colors.white, 16);
  }

  void _paintD6(Canvas canvas, Size size, Offset center) {
    final cubeSize = size.width * 0.6;
    
    // Draw 3D cube
    final frontPaint = Paint()
      ..color = const Color(0xFF3498DB)
      ..style = PaintingStyle.fill;
    
    final topPaint = Paint()
      ..color = const Color(0xFF5DADE2)
      ..style = PaintingStyle.fill;
    
    final sidePaint = Paint()
      ..color = const Color(0xFF2E86C1)
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    // Shadow
    final shadowRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(center.dx + 3, center.dy + 3), width: cubeSize, height: cubeSize),
      const Radius.circular(8),
    );
    canvas.drawRRect(shadowRect, shadowPaint);

    // Front face
    final frontRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: cubeSize, height: cubeSize),
      const Radius.circular(8),
    );
    canvas.drawRRect(frontRect, frontPaint);

    // Top face (3D effect)
    final topPath = Path();
    final offset = cubeSize * 0.15;
    topPath.moveTo(center.dx - cubeSize/2, center.dy - cubeSize/2);
    topPath.lineTo(center.dx - cubeSize/2 + offset, center.dy - cubeSize/2 - offset);
    topPath.lineTo(center.dx + cubeSize/2 + offset, center.dy - cubeSize/2 - offset);
    topPath.lineTo(center.dx + cubeSize/2, center.dy - cubeSize/2);
    topPath.close();
    canvas.drawPath(topPath, topPaint);

    // Right face (3D effect)
    final sidePath = Path();
    sidePath.moveTo(center.dx + cubeSize/2, center.dy - cubeSize/2);
    sidePath.lineTo(center.dx + cubeSize/2 + offset, center.dy - cubeSize/2 - offset);
    sidePath.lineTo(center.dx + cubeSize/2 + offset, center.dy + cubeSize/2 - offset);
    sidePath.lineTo(center.dx + cubeSize/2, center.dy + cubeSize/2);
    sidePath.close();
    canvas.drawPath(sidePath, sidePaint);

    // Draw dice dots (showing 6)
    _drawDiceDots(canvas, center, cubeSize * 0.8, 6);
  }

  void _paintD8(Canvas canvas, Size size, Offset center) {
    final paint = Paint()
      ..color = const Color(0xFF2ECC71)
      ..style = PaintingStyle.fill;
    
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final radius = size.width * 0.35;
    
    // Shadow diamond
    _drawDiamond(canvas, Offset(center.dx + 2, center.dy + 2), radius, shadowPaint);
    
    // Main diamond (D8)
    _drawDiamond(canvas, center, radius, paint);

    // Highlight
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..style = PaintingStyle.fill;
    
    _drawDiamond(canvas, Offset(center.dx - radius * 0.2, center.dy - radius * 0.2), radius * 0.6, highlightPaint);

    // Number
    _drawText(canvas, '8', center, Colors.white, 14);
  }

  void _paintD10(Canvas canvas, Size size, Offset center) {
    final paint = Paint()
      ..color = const Color(0xFFE67E22)
      ..style = PaintingStyle.fill;

    final radius = size.width * 0.35;
    
    // Draw pentagon-like shape for D10
    final path = Path();
    for (int i = 0; i < 5; i++) {
      final angle = (i * 2 * 3.14159) / 5 - 3.14159 / 2;
      final x = center.dx + radius * 0.8 * math.cos(angle);
      final y = center.dy + radius * 0.8 * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);

    _drawText(canvas, '10', center, Colors.white, 12);
  }

  void _paintD12(Canvas canvas, Size size, Offset center) {
    final paint = Paint()
      ..color = const Color(0xFF9B59B6)
      ..style = PaintingStyle.fill;

    final radius = size.width * 0.35;
    
    // Draw dodecagon (12-sided)
    final path = Path();
    for (int i = 0; i < 12; i++) {
      final angle = (i * 2 * 3.14159) / 12;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);

    _drawText(canvas, '12', center, Colors.white, 12);
  }

  void _paintD20(Canvas canvas, Size size, Offset center) {
    final paint = Paint()
      ..color = const Color(0xFFFFD700)
      ..style = PaintingStyle.fill;

    final radius = size.width * 0.35;
    
    // Draw icosahedron-like shape (20-sided)
    final path = Path();
    for (int i = 0; i < 20; i++) {
      final angle = (i * 2 * 3.14159) / 20;
      final radiusVar = radius * (0.8 + 0.2 * math.sin(i * 3.14159 / 3));
      final x = center.dx + radiusVar * math.cos(angle);
      final y = center.dy + radiusVar * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);

    // Gold highlight
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(Offset(center.dx - radius * 0.3, center.dy - radius * 0.3), radius * 0.3, highlightPaint);

    _drawText(canvas, '20', center, Colors.black, 12);
  }

  void _paintD100(Canvas canvas, Size size, Offset center) {
    final paint1 = Paint()
      ..color = const Color(0xFF34495E)
      ..style = PaintingStyle.fill;
    
    final paint2 = Paint()
      ..color = const Color(0xFF2C3E50)
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final radius = size.width * 0.3;
    
    // Shadow for first die
    canvas.drawCircle(Offset(center.dx - radius * 0.3 + 2, center.dy + 2), radius * 0.7, shadowPaint);
    canvas.drawCircle(Offset(center.dx + radius * 0.3 + 2, center.dy + 2), radius * 0.7, shadowPaint);
    
    // First D10 (left)
    canvas.drawCircle(Offset(center.dx - radius * 0.3, center.dy), radius * 0.7, paint1);
    
    // Second D10 (right, darker)
    canvas.drawCircle(Offset(center.dx + radius * 0.3, center.dy), radius * 0.7, paint2);

    // Add highlights
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(Offset(center.dx - radius * 0.5, center.dy - radius * 0.2), radius * 0.2, highlightPaint);
    canvas.drawCircle(Offset(center.dx + radius * 0.1, center.dy - radius * 0.2), radius * 0.2, highlightPaint);

    // Draw "00" instead of %
    _drawText(canvas, '00', center, Colors.white, 14);
  }

  void _drawDiamond(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    path.moveTo(center.dx, center.dy - radius);
    path.lineTo(center.dx + radius, center.dy);
    path.lineTo(center.dx, center.dy + radius);
    path.lineTo(center.dx - radius, center.dy);
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawDiceDots(Canvas canvas, Offset center, double size, int number) {
    final dotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final dotRadius = size * 0.06;
    final spacing = size * 0.2;

    // Draw 6 dots in 2x3 pattern
    final positions = [
      Offset(center.dx - spacing, center.dy - spacing),
      Offset(center.dx + spacing, center.dy - spacing),
      Offset(center.dx - spacing, center.dy),
      Offset(center.dx + spacing, center.dy),
      Offset(center.dx - spacing, center.dy + spacing),
      Offset(center.dx + spacing, center.dy + spacing),
    ];

    for (final pos in positions) {
      canvas.drawCircle(pos, dotRadius, dotPaint);
    }
  }

  void _drawText(Canvas canvas, String text, Offset center, Color color, double fontSize) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              color: Colors.black.withOpacity(0.8),
              offset: const Offset(1, 1),
              blurRadius: 2,
            ),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    
    final offset = Offset(
      center.dx - textPainter.width / 2,
      center.dy - textPainter.height / 2,
    );
    
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}