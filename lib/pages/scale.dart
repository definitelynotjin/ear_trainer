import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:ear_trainer/models/note.dart';
import 'package:ear_trainer/widgets/choice_button.dart';

class Scale extends StatefulWidget {
  const Scale({super.key});

  @override
  State<Scale> createState() => _ScaleState();
}

class _ScaleState extends State<Scale> {
  final _rnd = Random();
  final AudioPlayer _player = AudioPlayer();

  late final List<Note> _cMajor; // 8 notes C4..C5
  late int _missingIndex;
  late List<Note> _playable;
  late List<Note> _choices;

  @override
  void initState() {
    super.initState();
    // build explicit C major: use your Note.notes values and append C5
    _cMajor = [
      // reuse existing C4..B4 from Note.notes if ordering matches, otherwise explicit:
      const Note(name: 'C', octave: 4, frequency: 261.63, semitone: 0),
      const Note(name: 'D', octave: 4, frequency: 293.66, semitone: 2),
      const Note(name: 'E', octave: 4, frequency: 329.63, semitone: 4),
      const Note(name: 'F', octave: 4, frequency: 349.23, semitone: 5),
      const Note(name: 'G', octave: 4, frequency: 392.00, semitone: 7),
      const Note(name: 'A', octave: 4, frequency: 440.00, semitone: 9),
      const Note(name: 'B', octave: 4, frequency: 493.88, semitone: 11),
      const Note(name: 'C', octave: 5, frequency: 523.25, semitone: 12),
    ];
    _newQuestion();
  }

  void _newQuestion() {
    _missingIndex = _rnd.nextInt(_cMajor.length);
    _playable = List<Note>.from(_cMajor)..removeAt(_missingIndex);

    final correct = _cMajor[_missingIndex];
    final distractors = <Note>{};
    while (distractors.length < 2) {
      final candidate = _cMajor[_rnd.nextInt(_cMajor.length)];
      if (candidate.name != correct.name ||
          candidate.octave != correct.octave) {
        distractors.add(candidate);
      }
    }
    _choices = [correct, ...distractors].toList()..shuffle();
    setState(() {});
  }

  Future<void> _play(Note n) async {
    await _player.stop();
    await _player.play(AssetSource('audio/${n.name}${n.octave}.wav'));
  }

  void _answer(Note chosen) {
    final correct = _cMajor[_missingIndex];
    final isCorrect =
        chosen.name == correct.name && chosen.octave == correct.octave;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isCorrect
              ? 'Correct'
              : 'Wrong — correct: ${correct.name}${correct.octave}',
        ),
      ),
    );
    if (isCorrect)
      Future.delayed(const Duration(milliseconds: 700), _newQuestion);
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scale'),
        backgroundColor: const Color.fromARGB(255, 32, 32, 32),
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),

      backgroundColor: const Color.fromARGB(255, 32, 32, 32),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 8),
            const Text(
              'Guess the missing note in the C major scale',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            const SizedBox(height: 12),
            const Text(
              'Playable notes (tap to hear):',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: _playable.map((n) {
                return GestureDetector(
                  onTap: () => _play(n),
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white24, width: 0.5),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${n.name}${n.octave}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'tap to play',
                          style: TextStyle(fontSize: 12, color: Colors.white38),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            const Text(
              'Which note is missing?',
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 12),

            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: _choices.map((c) {
                return SizedBox(
                  width: 160,
                  height: 72,
                  child: ChoiceButton(
                    answer: 'note',
                    onPressed: () => _answer(c),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
