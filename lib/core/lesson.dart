
import 'dart:math';


class Lesson {

  String currentNote;
  static const notes = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'A#', 'B#', 'C#', 'D#', 'E#', 'F#', 'G#'];

  Lesson(this.currentNote);

  String getNextNote() {
    int next = Random().nextInt(Lesson.notes.length);
    currentNote = notes[next];
    return currentNote;
  }

}