import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:music_notes/core/lesson.dart';

/// A widget that draws a musical staff (pentagram) with a note on it
class MusicalStaff extends StatelessWidget {
  final String note;
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
            top: clefType == ClefType.treble ? height / 3 - 20 : height / 3 + 10,
            child: SvgPicture.asset(
              clefType == ClefType.treble ? 'assets/gclef.svg' : 'assets/fclef.svg',
              width: 40,
              height: clefType == ClefType.treble ? 110 : 80,
              colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
            ),
          ),
        ],
      ),
    );
  }
}

class StaffPainter extends CustomPainter {
  final String note;
  final ClefType clefType;

  StaffPainter({required this.note, this.clefType = ClefType.treble});

  // Map notes to their vertical positions on the staff
  // Position 0 is the top line, position 4 is the bottom line
  // Positive numbers go down, negative numbers go up
  static const Map<String, int> _trebleNotePositions = {
    // Treble clef notes (G clef)
    'C': 10,   // Below the staff
    'D': 9,
    'E': 8,
    'F': 7,
    'G': 6,
    'A': 5,
    'B': 4,   // Middle line
    'C#': 10,
    'D#': 9,
    'F#': 7,
    'G#': 6,
    'A#': 5,
  };

  static const Map<String, int> _bassNotePositions = {
    // Bass clef notes (F clef)
    'C': 6,    // Middle line
    'D': 5,
    'E': 4,
    'F': 3,    // Top space
    'G': 2,
    'A': 1,    // Above staff
    'B': 0,
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

    // Draw the note
    final notePositions = clefType == ClefType.treble ? _trebleNotePositions : _bassNotePositions;
    final notePosition = notePositions[note] ?? 0;
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
