import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:ear_trainer/widgets/pagebar.dart';
import 'package:ear_trainer/widgets/note_button.dart';
import 'package:ear_trainer/widgets/arrow_button.dart';
import 'package:ear_trainer/widgets/help.dart';
import 'package:ear_trainer/models/note.dart';
import 'package:ear_trainer/models/achievements.dart';
import 'dart:math' as math;

class Pitch extends StatefulWidget {
  const Pitch({super.key});

  @override
  State<Pitch> createState() => _PitchState();
}

class _PitchState extends State<Pitch> {
  final _rnd = math.Random();
  final AudioPlayer _player = AudioPlayer();
  late Note leftNote;
  late Note rightNote;
  int _scoreCount = 0;
  int _streakCount = 0;
  int _questionCount = 0;
  bool _leftPlayed = false;
  bool _rightPlayed = false;
  bool get _canChoose => _leftPlayed && _rightPlayed;

  void _nextQuestion() {
    int a = _rnd.nextInt(Note.notes.length);
    int b;
    do {
      b = _rnd.nextInt(Note.notes.length);
    } while (b == a);
    setState(() {
      leftNote = Note.notes[a];
      rightNote = Note.notes[b];
      _leftPlayed = false;
      _rightPlayed = false;
    });
  }

  @override
  void initState() {
    super.initState();
    Achievement.markExerciseUsed('pitch');
    _nextQuestion();
  }

  Future<void> _play(Note note) async {
    await _player.stop();
    final asset = 'audio/${note.name}${note.octave}.wav';
    await _player.play(AssetSource(asset));
    setState(() {
      if (note == leftNote) {
        _leftPlayed = true;
      } else if (note == rightNote) {
        _rightPlayed = true;
      }
    });
  }

  void _score(bool leftChosen) {
    final bool correct = leftChosen
        ? leftNote.frequency > rightNote.frequency
        : rightNote.frequency > leftNote.frequency;
    setState(() {
      _questionCount++;
      if (correct) _scoreCount++;
      _streakCount = correct ? _streakCount + 1 : 0;
    });

    if (correct && _scoreCount == 1) {
      Achievement.unlock('first_note');
    }
    if (_streakCount >= 5) {
      Achievement.unlock('perfect_pitch');
    }
    if (_questionCount >= 10) {
      Achievement.unlock('pitch_veteran');
      if (_scoreCount >= 10) {
        Achievement.unlock('flawless');
      }
    }

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(correct ? 'Correct' : 'Incorrect'),
        backgroundColor: correct ? Colors.green : Colors.red,
      ),
    );
    _nextQuestion();
  }

  void _chooseLeft() {
    _score(true);
  }

  void _chooseRight() {
    _score(false);
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
        foregroundColor: Colors.white,
        title: Text(
          'Pitch',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Help(
              helpIcon: 'assets/icons/help.svg',
              size: 25,
              title: 'Pitch Training',
              content:
                  '1. Listen to the notes\nTap both circle buttons to hear the two different notes.\n\n'
                  '2. Compare the pitch\nDecide which of the two notes sounds HIGHER.\n\n'
                  '3. Make your choice\nTap the LEFT arrow if the first note is higher, or tap the RIGHT arrow if the second note is higher.',
            ),
          ),
        ],
        backgroundColor: Color.fromARGB(255, 32, 32, 32).withValues(alpha: 0.1),
      ),
      backgroundColor: Color.fromARGB(255, 32, 32, 32),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: StepProgressBar(
              totalSteps: 10,
              onStepChanged: (i) => debugPrint('step $i'),
            ),
          ),
          Text(
            'Score: $_scoreCount',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            'Streak: $_streakCount',
            style: const TextStyle(fontSize: 16, color: Colors.white70),
          ),
          const SizedBox(height: 80),
          const Text(
            'Which note is higher?',
            style: TextStyle(fontSize: 20, color: Colors.white70),
          ),
          const SizedBox(height: 120),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleNoteButton(
                  circleIcon: 'assets/icons/circle.svg',
                  soundAsset: 'audio/${leftNote.name}${leftNote.octave}.wav',
                  onPressed: () => _play(leftNote),
                ),
                const SizedBox(width: 1),
                CircleNoteButton(
                  circleIcon: 'assets/icons/circle.svg',
                  soundAsset: 'audio/${rightNote.name}${rightNote.octave}.wav',
                  onPressed: () => _play(rightNote),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ArrowButton(
                    arrowIcon: 'assets/icons/arrow_left.svg',
                    onPressed: _canChoose
                        ? _chooseLeft
                        : () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.blue,
                                content: Text('Play both the notes first '),
                              ),
                            );
                          },
                  ),
                  // Transform.rotate(angle: -math.pi / 120),
                  ArrowButton(
                    arrowIcon: 'assets/icons/arrow_right.svg',
                    onPressed: _canChoose
                        ? _chooseRight
                        : () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.blue,
                                content: Text('Play both the notes first'),
                              ),
                            );
                          },
                  ),
                ],
              ),
            ],
          ),
          // Row(
          //   children: [
          //     QuizNavigationButton(
          //       navIcon: 'assets/icons/arrow_left.svg',
          //       label: 'rawr',
          //       onTap: () {},
          //     ),

          //     QuizNavigationButton(
          //       navIcon: 'assets/icons/arrow_right.svg',
          //       label: 'rawr',
          //       onTap: () {},
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
