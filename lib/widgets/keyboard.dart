import 'package:flutter/material.dart';

class PianoKeyboard extends StatelessWidget {
  final void Function(String note)? onKeyPressed;

  const PianoKeyboard({super.key, this.onKeyPressed});

  @override
  Widget build(BuildContext context) {
    final whiteKeys = ['C', 'D', 'E', 'F', 'G', 'A', 'B'];
    final blackKeys = ['C#', 'D#', '', 'F#', 'G#', 'A#', ''];
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

          // Black keys (positioned on top)
          Positioned.fill(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(whiteKeys.length, (index) {
                final note = blackKeys[index];
                if (note.isEmpty) {
                  return SizedBox(width: whiteKeyWidth);
                }

                // Position black key centered between white keys (like a real piano)
                return SizedBox(
                  width: whiteKeyWidth,
                  child: Align(
                    alignment: Alignment.center,
                    child: Transform.translate(
                      offset: Offset(whiteKeyWidth / 2, -40),
                      child: GestureDetector(
                        onTap: () => onKeyPressed?.call(note),
                        child: Container(
                          width: blackKeyWidth,
                          height: blackKeyHeight,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 3,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
