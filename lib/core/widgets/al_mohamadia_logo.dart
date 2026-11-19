import 'package:flutter/material.dart';

/// AL-MOHAMADIA wordmark and the interlocking arch emblem.
class AlMohamadiaLogo extends StatelessWidget {
  const AlMohamadiaLogo({super.key, this.width = 220, this.light = false});

  final double width;
  final bool light;

  @override
  Widget build(BuildContext context) {
    final color = light ? const Color(0xFFF3EDEA) : const Color(0xFF8D7A70);
    return SizedBox(
      width: width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomPaint(size: Size(width * .86, width * .38), painter: _ArchMarkPainter()),
          const SizedBox(height: 7),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text('ALMOHAMADIA', style: TextStyle(
              color: color, fontSize: 21, fontWeight: FontWeight.w400,
              letterSpacing: .5, height: 1,
            )),
          ),
          const SizedBox(height: 3),
          Text('COMPOUND', style: TextStyle(
            color: color, fontSize: 12, fontWeight: FontWeight.w400,
            letterSpacing: .7, height: 1,
          )),
        ],
      ),
    );
  }
}

class _ArchMarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final light = Paint()..color = const Color(0xFFB9AEA8);
    final dark = Paint()..color = const Color(0xFF95837A);
    final p = Path()
      ..moveTo(0, size.height * .92)
      ..lineTo(size.width * .25, size.height * .05)
      ..cubicTo(size.width * .29, size.height * .42, size.width * .36, size.height * .70, size.width * .5, size.height * .86)
      ..cubicTo(size.width * .64, size.height * .70, size.width * .71, size.height * .42, size.width * .75, size.height * .05)
      ..lineTo(size.width, size.height * .92)
      ..lineTo(size.width * .82, size.height * .92)
      ..lineTo(size.width * .72, size.height * .60)
      ..cubicTo(size.width * .69, size.height * .85, size.width * .61, size.height, size.width * .5, size.height)
      ..cubicTo(size.width * .39, size.height, size.width * .31, size.height * .85, size.width * .28, size.height * .60)
      ..lineTo(size.width * .18, size.height * .92)
      ..close();
    canvas.drawPath(p, light);
    final sides = Path()
      ..moveTo(0, size.height * .92)
      ..lineTo(size.width * .25, size.height * .05)
      ..lineTo(size.width * .31, size.height * .36)
      ..lineTo(size.width * .19, size.height * .76)
      ..lineTo(size.width * .13, size.height * .92)
      ..close()
      ..moveTo(size.width, size.height * .92)
      ..lineTo(size.width * .75, size.height * .05)
      ..lineTo(size.width * .69, size.height * .36)
      ..lineTo(size.width * .81, size.height * .76)
      ..lineTo(size.width * .87, size.height * .92)
      ..close();
    canvas.drawPath(sides, dark);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
