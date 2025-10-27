import 'package:flutter/material.dart';

class PianoKeyboard extends StatelessWidget {
  final void Function(String note)? onKeyPressed;

  const PianoKeyboard({super.key, this.onKeyPressed});

  @override
  Widget build(BuildContext context) {
    final whiteKeys = ['C', 'D', 'E', 'F', 'G', 'A', 'B'];
    // Black keys positioned between white keys: after C, D, F, G, A
    final blackKeyPositions = {
      'C#': 0, // After C
      'D#': 1, // After D
      'F#': 3, // After F
      'G#': 4, // After G
      'A#': 5, // After A
    };
    final whiteKeyWidth = 60.0;
    final whiteKeyHeight = 200.0;
    final blackKeyWidth = 40.0;
    final blackKeyHeight = 120.0;

    return SizedBox(
      height: whiteKeyHeight,
      width: whiteKeys.length * whiteKeyWidth,
      child: Stack(
        children: [
          // White keys
          Row(
            mainAxisSize: MainAxisSize.min,
            children: whiteKeys.map((note) {
              return GestureDetector(
                onTap: () => onKeyPressed?.call(note),
                child: Container(
                  width: whiteKeyWidth,
                  height: whiteKeyHeight,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black),
                  ),
                ),
              );
            }).toList(),
          ),

          // Black keys (positioned absolutely between white keys)
          ...blackKeyPositions.entries.map((entry) {
            final note = entry.key;
            final whiteKeyIndex = entry.value;
            // Position black key at the right edge of the white key (between two white keys)
            final leftPosition = (whiteKeyIndex + 1) * whiteKeyWidth - (blackKeyWidth / 2);

            return Positioned(
              left: leftPosition,
              top: 0,
              child: GestureDetector(
                onTap: () => onKeyPressed?.call(note),
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: blackKeyWidth,
                  height: blackKeyHeight,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.black, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 3,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
