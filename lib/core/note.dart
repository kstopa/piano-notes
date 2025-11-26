class Note {
  final String name;
  final int octave;

  const Note(this.name, this.octave);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Note &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          octave == other.octave;

  @override
  int get hashCode => name.hashCode ^ octave.hashCode;

  @override
  String toString() => '$name$octave';

  /// Returns the diatonic position of the note relative to C.
  /// C=0, D=1, E=2, F=3, G=4, A=5, B=6
  int get diatonicOffset {
    switch (name.replaceAll('#', '')) {
      case 'C':
        return 0;
      case 'D':
        return 1;
      case 'E':
        return 2;
      case 'F':
        return 3;
      case 'G':
        return 4;
      case 'A':
        return 5;
      case 'B':
        return 6;
      default:
        return 0;
    }
  }
}
