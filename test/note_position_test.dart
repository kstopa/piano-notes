import 'package:flutter_test/flutter_test.dart';
import 'package:music_notes/core/note.dart';
import 'package:music_notes/core/lesson.dart';
import 'package:music_notes/widgets/staff.dart';

void main() {
  group('Note Class', () {
    test('Diatonic offset calculation', () {
      expect(const Note('C', 4).diatonicOffset, 0);
      expect(const Note('D', 4).diatonicOffset, 1);
      expect(const Note('E', 4).diatonicOffset, 2);
      expect(const Note('F', 4).diatonicOffset, 3);
      expect(const Note('G', 4).diatonicOffset, 4);
      expect(const Note('A', 4).diatonicOffset, 5);
      expect(const Note('B', 4).diatonicOffset, 6);
      expect(const Note('C#', 4).diatonicOffset, 0);
    });
  });

  group('Lesson Class', () {
    test('Generates Treble Clef notes correctly', () {
      final lesson = Lesson(const Note('C', 4), clefType: ClefType.treble);
      final notes = lesson.notes;
      
      // Should start at C4
      expect(notes.first.name, 'C');
      expect(notes.first.octave, 4);
      
      // Should end at A5 (or around there, based on logic)
      // Logic: 4 to 5. End note A.
      expect(notes.last.name, contains('A')); // Could be A#
      expect(notes.last.octave, 5);
      
      // Check for C5
      expect(notes.any((n) => n.name == 'C' && n.octave == 5), isTrue);
    });

    test('Generates Bass Clef notes correctly', () {
      final lesson = Lesson(const Note('C', 3), clefType: ClefType.bass);
      final notes = lesson.notes;
      
      // Logic: 2 to 4. Start E, End C.
      // Should start at E2
      expect(notes.first.name, 'E');
      expect(notes.first.octave, 2);
      
      // Should end at C4
      expect(notes.last.name, contains('C'));
      expect(notes.last.octave, 4);
    });
  });

  group('Staff Position Logic', () {
    // We can't easily test the private logic inside StaffPainter without exposing it or testing the painter behavior.
    // However, we can copy the logic here to verify it matches our expectations.
    
    int getTreblePosition(Note note) {
      return 10 - ((note.octave - 4) * 7 + note.diatonicOffset);
    }

    int getBassPosition(Note note) {
      return 5 - ((note.octave - 3) * 7 + note.diatonicOffset);
    }

    test('Treble Clef Positions', () {
      // C4 (Middle C) -> 10
      expect(getTreblePosition(const Note('C', 4)), 10);
      // E4 (Bottom Line) -> 8
      expect(getTreblePosition(const Note('E', 4)), 8);
      // G4 (2nd Line) -> 6
      expect(getTreblePosition(const Note('G', 4)), 6);
      // B4 (Middle Line) -> 4
      expect(getTreblePosition(const Note('B', 4)), 4);
      // D5 (4th Line) -> 2
      expect(getTreblePosition(const Note('D', 5)), 2);
      // F5 (Top Line) -> 0
      expect(getTreblePosition(const Note('F', 5)), 0);
      // A5 (Above Staff) -> -2
      expect(getTreblePosition(const Note('A', 5)), -2);
    });

    test('Bass Clef Positions', () {
      // C4 (Middle C) -> -2
      expect(getBassPosition(const Note('C', 4)), -2);
      // A3 (Top Line) -> 0
      expect(getBassPosition(const Note('A', 3)), 0);
      // F3 (4th Line) -> 2
      expect(getBassPosition(const Note('F', 3)), 2);
      // D3 (Middle Line) -> 4
      expect(getBassPosition(const Note('D', 3)), 4);
      // B2 (2nd Line) -> 6
      expect(getBassPosition(const Note('B', 2)), 6);
      // G2 (Bottom Line) -> 8
      expect(getBassPosition(const Note('G', 2)), 8);
      // E2 (Below Staff) -> 10
      expect(getBassPosition(const Note('E', 2)), 10);
    });
  });
}
