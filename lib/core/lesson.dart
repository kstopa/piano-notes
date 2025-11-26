import 'dart:math';
import 'package:music_notes/core/note.dart';

enum ClefType {
  treble,
  bass,
}

class Lesson {
  Note currentNote;
  final ClefType clefType;

  Lesson(this.currentNote, {this.clefType = ClefType.treble});

  List<Note> get notes {
    if (clefType == ClefType.treble) {
      // Treble clef: C4 to A5
      return _generateNotes(4, 5, endNote: 'A');
    } else {
      // Bass clef: E2 to C4
      return _generateNotes(2, 4, startNote: 'E', endNote: 'C');
    }
  }

  List<Note> _generateNotes(int startOctave, int endOctave, {String startNote = 'C', String endNote = 'B'}) {
    final noteNames = ['C', 'D', 'E', 'F', 'G', 'A', 'B'];
    final allNotes = <Note>[];

    for (int octave = startOctave; octave <= endOctave; octave++) {
      for (final name in noteNames) {
        if (octave == startOctave && noteNames.indexOf(name) < noteNames.indexOf(startNote)) continue;
        if (octave == endOctave && noteNames.indexOf(name) > noteNames.indexOf(endNote)) continue;
        
        allNotes.add(Note(name, octave));
        
        if (['C', 'D', 'F', 'G', 'A'].contains(name)) {
           if (octave == endOctave && noteNames.indexOf(name) >= noteNames.indexOf(endNote)) continue; // Don't add sharp if natural is last
           allNotes.add(Note('$name#', octave));
        }
      }
    }
    return allNotes;
  }

  Note getNextNote() {
    final availableNotes = notes;
    int next = Random().nextInt(availableNotes.length);
    if (availableNotes[next] == currentNote) {
      return getNextNote();
    }
    currentNote = availableNotes[next];
    return currentNote;
  }
}
