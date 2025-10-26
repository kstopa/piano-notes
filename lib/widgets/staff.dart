import 'package:flutter/material.dart';

/// A widget that draws a musical staff (pentagram) with a note on it
class MusicalStaff extends StatelessWidget {
  final String note;
  final double width;
  final double height;

  const MusicalStaff({
    super.key,
    required this.note,
    this.width = 400,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, height),
      painter: StaffPainter(note: note),
    );
  }
}

class StaffPainter extends CustomPainter {
  final String note;

  StaffPainter({required this.note});

  // Map notes to their vertical positions on the staff
  // Position 0 is the middle line (B in treble clef)
  // Positive numbers go down, negative numbers go up
  static const Map<String, int> _notePositions = {
    // Treble clef notes
    'C': 6,   // Below the staff
    'D': 5,
    'E': 4,
    'F': 3,
    'G': 2,
    'A': 1,
    'B': 0,   // Middle line
    'C#': 6,
    'D#': 5,
    'F#': 3,
    'G#': 2,
    'A#': 1,
  };

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    // Calculate staff dimensions
    final staffLineSpacing = size.height / 12;
    final staffStartY = size.height / 3;
    final staffStartX = 20.0;
    final staffEndX = size.width - 20;

    // Draw the 5 staff lines
    for (int i = 0; i < 5; i++) {
      final y = staffStartY + (i * staffLineSpacing);
      canvas.drawLine(
        Offset(staffStartX, y),
        Offset(staffEndX, y),
        paint,
      );
    }

    // Draw treble clef (simplified G clef)
    _drawTrebleClef(canvas, staffStartX + 10, staffStartY, staffLineSpacing, fillPaint);

    // Draw the note
    final notePosition = _notePositions[note] ?? 0;
    final noteY = staffStartY + (notePosition * staffLineSpacing / 2);
    final noteX = staffStartX + 100;

    // Draw ledger lines if note is outside the staff
    if (notePosition > 4) {
      // Below the staff
      for (int i = 5; i <= notePosition; i++) {
        if (i % 2 == 0) {
          final ledgerY = staffStartY + (i * staffLineSpacing / 2);
          canvas.drawLine(
            Offset(noteX - 15, ledgerY),
            Offset(noteX + 15, ledgerY),
            paint,
          );
        }
      }
    } else if (notePosition < 0) {
      // Above the staff
      for (int i = -1; i >= notePosition; i--) {
        if (i % 2 == 0) {
          final ledgerY = staffStartY + (i * staffLineSpacing / 2);
          canvas.drawLine(
            Offset(noteX - 15, ledgerY),
            Offset(noteX + 15, ledgerY),
            paint,
          );
        }
      }
    }

    // Draw note head (filled ellipse)
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(noteX, noteY),
        width: 20,
        height: 14,
      ),
      fillPaint,
    );

    // Draw note stem
    final stemHeight = staffLineSpacing * 3.5;
    if (notePosition <= 0) {
      // Stem goes down for notes above middle line
      canvas.drawLine(
        Offset(noteX - 10, noteY),
        Offset(noteX - 10, noteY + stemHeight),
        Paint()
          ..color = Colors.black
          ..strokeWidth = 2,
      );
    } else {
      // Stem goes up for notes below middle line
      canvas.drawLine(
        Offset(noteX + 10, noteY),
        Offset(noteX + 10, noteY - stemHeight),
        Paint()
          ..color = Colors.black
          ..strokeWidth = 2,
      );
    }

    // Draw sharp symbol if needed
    if (note.contains('#')) {
      _drawSharp(canvas, noteX - 30, noteY, staffLineSpacing / 4, paint);
    }
  }

  void _drawTrebleClef(Canvas canvas, double x, double y, double spacing, Paint paint) {
    // Simplified treble clef shape
    final path = Path();

    // Start at the second line (G line)
    final gLineY = y + spacing;

    // Draw a stylized G clef
    path.moveTo(x, gLineY);
    path.quadraticBezierTo(
      x + 10, gLineY - spacing * 2,
      x, gLineY - spacing,
    );
    path.quadraticBezierTo(
      x - 10, gLineY,
      x, gLineY + spacing,
    );
    path.quadraticBezierTo(
      x + 15, gLineY + spacing * 2,
      x + 10, gLineY + spacing * 3,
    );

    canvas.drawPath(path, paint);

    // Draw the curl at the bottom
    canvas.drawCircle(Offset(x + 5, gLineY + spacing * 3.5), 3, paint);
  }

  void _drawSharp(Canvas canvas, double x, double y, double size, Paint paint) {
    // Draw two vertical lines
    canvas.drawLine(
      Offset(x - size, y - size * 1.5),
      Offset(x - size, y + size * 1.5),
      paint,
    );
    canvas.drawLine(
      Offset(x + size, y - size * 1.5),
      Offset(x + size, y + size * 1.5),
      paint,
    );

    // Draw two horizontal lines (slightly slanted)
    canvas.drawLine(
      Offset(x - size * 1.5, y - size * 0.5),
      Offset(x + size * 1.5, y - size * 0.8),
      paint,
    );
    canvas.drawLine(
      Offset(x - size * 1.5, y + size * 0.8),
      Offset(x + size * 1.5, y + size * 0.5),
      paint,
    );
  }

  @override
  bool shouldRepaint(StaffPainter oldDelegate) {
    return oldDelegate.note != note;
  }
}
