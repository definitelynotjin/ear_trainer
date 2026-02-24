class Note {
  final String name;
  final int octave;
  final double frequency;

  const Note({
    required this.name,
    required this.octave,
    required this.frequency,
  });

  static const List<Note> notes = [
    Note(name: 'C', octave: 4, frequency: 261.63),
    Note(name: 'D', octave: 4, frequency: 293.66),
    Note(name: 'E', octave: 4, frequency: 329.63),
    Note(name: 'F', octave: 4, frequency: 349.23),
    Note(name: 'G', octave: 4, frequency: 392.00),
    Note(name: 'A', octave: 4, frequency: 440.00),
    Note(name: 'B', octave: 4, frequency: 493.88),
  ];
}
