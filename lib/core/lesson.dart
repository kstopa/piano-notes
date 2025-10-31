
import 'dart:math';

enum ClefType {
  treble,
  bass,
}

class Lesson {

  String currentNote;
  final ClefType clefType;

  // Treble clef notes (G clef) - higher register
  static const trebleNotes = ['C', 'D', 'E', 'F', 'G', 'A', 'B', 'C#', 'D#', 'F#', 'G#', 'A#'];

  // Bass clef notes (F clef) - lower register
  static const bassNotes = ['C', 'D', 'E', 'F', 'G', 'A', 'B', 'C#', 'D#', 'F#', 'G#', 'A#'];

  Lesson(this.currentNote, {this.clefType = ClefType.treble});

  List<String> get notes {
    return clefType == ClefType.treble ? trebleNotes : bassNotes;
  }

  String getNextNote() {
    int next = Random().nextInt(notes.length);
    if (notes[next] == currentNote) {
      return getNextNote();
    }
    currentNote = notes[next];
    return currentNote;
  }

}
