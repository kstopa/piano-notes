import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:music_notes/core/lesson.dart';
import 'package:music_notes/core/note.dart';

/// A widget that draws a musical staff (pentagram) with a note on it
class MusicalStaff extends StatelessWidget {
  final Note note;
  final double width;
  final double height;
  final ClefType clefType;

  const MusicalStaff({
    super.key,
    required this.note,
    this.width = 400,
    this.height = 200,
    this.clefType = ClefType.treble,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: [
          CustomPaint(
            size: Size(width, height),
            painter: StaffPainter(note: note, clefType: clefType),
          ),
          // Position the clef SVG on the staff
          Positioned(
            left: 30,
            top: clefType == ClefType.treble ? height / 3 - 20 : height / 3 + 2,
            child: SvgPicture.asset(
              clefType == ClefType.treble ? 'assets/gclef.svg' : 'assets/fclef.svg',
              width: 40,
              height: clefType == ClefType.treble ? 110 : 55,
              colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
            ),
          ),
        ],
      ),
    );
  }
}

class StaffPainter extends CustomPainter {
  final Note note;
  final ClefType clefType;

  StaffPainter({required this.note, this.clefType = ClefType.treble});

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

    // Calculate note position
    int notePosition;
    if (clefType == ClefType.treble) {
      // Treble clef: C4 is position 10 (line below staff)
      // Formula: 10 - ((octave - 4) * 7 + diatonicOffset)
      notePosition = 10 - ((note.octave - 4) * 7 + note.diatonicOffset);
    } else {
      // Bass clef: C3 is position 5 (2nd space from bottom)
      // Formula: 5 - ((octave - 3) * 7 + note.diatonicOffset)
      notePosition = 5 - ((note.octave - 3) * 7 + note.diatonicOffset);
    }

    final noteY = staffStartY + (notePosition * staffLineSpacing / 2);
    final noteX = staffStartX + 100;

    // Draw ledger lines if note is outside the staff
    if (notePosition > 8) {
      // Below the staff (position 8 is bottom line)
      // Ledger lines are at even positions: 10, 12, etc.
      // If position is odd (space), we need ledger line above it?
      // E.g. C4 is 10. Ledger line at 10.
      // B3 is 11. Ledger line at 10.
      // A3 is 12. Ledger line at 12.
      for (int i = 10; i <= notePosition; i++) {
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
      // Above the staff (position 0 is top line)
      // Ledger lines at -2, -4, etc.
      // A5 is -1. Ledger line at -2? No.
      // C6 is -4. Ledger line at -2, -4.
      for (int i = -2; i >= notePosition; i--) {
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
    if (notePosition <= 4) {
      // Stem goes down for notes on or above middle line (pos 4)
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
    if (note.name.contains('#')) {
      _drawSharp(canvas, noteX - 30, noteY, staffLineSpacing / 4, paint);
    }
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
    return oldDelegate.note != note || oldDelegate.clefType != clefType;
  }
}
