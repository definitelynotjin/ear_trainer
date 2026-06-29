class Note {
  final String name;
  final int octave;
  final double frequency;
  final int semitone;

  const Note({
    required this.name,
    required this.octave,
    required this.frequency,
    required this.semitone,
  });

  static const List<Note> notes = [
    Note(name: 'C', octave: 4, frequency: 261.63, semitone: 0),
    Note(name: 'D', octave: 4, frequency: 293.66, semitone: 2),
    Note(name: 'E', octave: 4, frequency: 329.63, semitone: 4),
    Note(name: 'F', octave: 4, frequency: 349.23, semitone: 5),
    Note(name: 'G', octave: 4, frequency: 392.00, semitone: 7),
    Note(name: 'A', octave: 4, frequency: 440.00, semitone: 9),
    Note(name: 'B', octave: 4, frequency: 493.88, semitone: 11),
    Note(name: 'C', octave: 5, frequency: 523.25, semitone: 12),
  ];
}
