import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:ear_trainer/models/note.dart';
import 'package:ear_trainer/models/achievements.dart';
import 'package:ear_trainer/widgets/choice_button.dart';
import 'package:ear_trainer/widgets/help.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Scale extends StatefulWidget {
  const Scale({super.key});

  @override
  State<Scale> createState() => _ScaleState();
}

class _ScaleState extends State<Scale> {
  final _rnd = Random();
  final AudioPlayer _player = AudioPlayer();
  static const Duration _highlightDuration = Duration(seconds: 5);

  late final List<Note> _cMajor; // 8 notes C4..C5
  late int _missingIndex;
  late List<Note> _playable;
  late List<Note> _choices;
  int _highlightedPlayableIndex = -1;
  int _highlightedChoiceIndex = -1;
  int _previewedChoiceIndex = -1;
  Timer? _highlightResetTimer;
  Timer? _choiceHighlightResetTimer;

  @override
  void initState() {
    super.initState();
    Achievement.markExerciseUsed('scale');
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
    _highlightResetTimer?.cancel();
    _choiceHighlightResetTimer?.cancel();
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
    _highlightedPlayableIndex = -1;
    _highlightedChoiceIndex = -1;
    _previewedChoiceIndex = -1;
    setState(() {});
  }

  Future<void> _play(Note n) async {
    await _player.stop();
    await _player.play(AssetSource('audio/${n.name}${n.octave}.wav'));
  }

  Future<void> _playPlayable(Note note, int index) async {
    await _play(note);
    if (!mounted) return;
    setState(() {
      _highlightedPlayableIndex = index;
    });

    _highlightResetTimer?.cancel();
    _highlightResetTimer = Timer(_highlightDuration, () {
      if (!mounted) return;
      setState(() {
        _highlightedPlayableIndex = -1;
      });
    });
  }

  Future<void> _previewChoice(Note note, int index) async {
    if (_previewedChoiceIndex != index) {
      await _play(note);
      if (!mounted) return;
      setState(() {
        _previewedChoiceIndex = index;
        _highlightedChoiceIndex = index;
      });
      _choiceHighlightResetTimer?.cancel();
      _choiceHighlightResetTimer = Timer(_highlightDuration, () {
        if (!mounted) return;
        setState(() {
          _highlightedChoiceIndex = -1;
        });
      });
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Previewed. Tap the same choice again to choose it.'),
        ),
      );
      return;
    }

    _answer(note);
  }

  void _answer(Note chosen) {
    final correct = _cMajor[_missingIndex];
    final isCorrect =
        chosen.name == correct.name && chosen.octave == correct.octave;
    setState(() {
      _previewedChoiceIndex = -1;
    });
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isCorrect
              ? 'Correct'
              : 'Wrong — Correct: ${correct.name}${correct.octave}',
        ),
        backgroundColor: isCorrect ? Colors.green : Colors.red,
      ),
    );
    if (isCorrect)
      Future.delayed(const Duration(milliseconds: 700), _newQuestion);
  }

  @override
  void dispose() {
    _highlightResetTimer?.cancel();
    _choiceHighlightResetTimer?.cancel();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scale'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Help(
              helpIcon: 'assets/icons/help.svg',
              size: 25,
              title: 'How to Play: Scale',
              content:
                  '1. Listen to the scale\nTap the note buttons at the top to hear the notes of the C Major scale. One note has been removed!\n\n'
                  '2. Find the missing note\nListen carefully to the gaps in the scale. Which note is missing?\n\n'
                  '3. Make your choice\nTap a choice button at the bottom once to preview its sound. Tap the exact same button a SECOND time to submit it as your final answer.',
            ),
          ),
        ],
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
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 48),
            const Text(
              'Playable notes (tap to hear):',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: _playable.asMap().entries.map((entry) {
                final index = entry.key;
                final n = entry.value;
                final isHighlighted = _highlightedPlayableIndex == index;

                return GestureDetector(
                  onTap: () => _playPlayable(n, index),
                  child: Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      color: isHighlighted
                          ? Colors.tealAccent.withValues(alpha: 0.18)
                          : Colors.white10,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isHighlighted
                            ? Colors.tealAccent
                            : Colors.white24,
                        width: 0.8,
                      ),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/icons/waves.svg',
                        width: 56,
                        height: 56,
                        fit: BoxFit.contain,
                        colorFilter: ColorFilter.mode(
                          isHighlighted ? Colors.tealAccent : Colors.white60,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 80),
            const Text(
              'Which note is missing?',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 12),

            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: _choices.asMap().entries.map((entry) {
                final index = entry.key;
                final c = entry.value;
                final isPreviewed = _previewedChoiceIndex == index;

                return SizedBox(
                  width: 180,
                  height: 82,
                  child: ChoiceButton(
                    answer: '${c.name}${c.octave}',
                    subtitle: isPreviewed
                        ? 'tap again to choose'
                        : 'tap to preview',
                    highlighted: _highlightedChoiceIndex == index,
                    onPressed: () => _previewChoice(c, index),
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
