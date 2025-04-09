import 'package:flutter/material.dart';

class DashedLine extends StatelessWidget {
  final double width;
  final double height;

  const DashedLine({Key? key, this.width = double.infinity, this.height = 1.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, height),
      painter: DashedLinePainter(),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.grey  // Line color
      ..strokeWidth = 0.5;      // Line thickness

    double dashWidth = 6.0;   // Width of each dash
    double dashSpace = 4.0;   // Space between dashes
    double startX = 0.0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
