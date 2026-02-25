import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:ear_trainer/widgets/pagebar.dart';
import 'package:ear_trainer/widgets/note_button.dart';
import 'package:ear_trainer/widgets/arrow_button.dart';
import 'package:ear_trainer/widgets/quiz_navigation_button.dart';
import 'package:ear_trainer/models/pitchquestions.dart';
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

  void _nextQuestion() {
    int a = _rnd.nextInt(Note.notes.length);
    int b;
    do {
      b = _rnd.nextInt(Note.notes.length);
    } while (b == a);
    setState(() {
      leftNote = Note.notes[a];
      rightNote = Note.notes[b];
    });
  }

  @override
  void initState() {
    super.initState();
    _nextQuestion();
  }

  Future<void> _play(Note note) async {
    await _player.stop();
    final asset = 'audio/${note.name}${note.octave}.wav';
    await _player.play(AssetSource(asset));
  }

  void _score() {
    String right;
    String wrong;
  }

  void _chooseLeft() {
    final correct = leftNote.frequency > rightNote.frequency;
    _nextQuestion();
  }

  void _chooseRight() {
    final correct = rightNote.frequency > leftNote.frequency;
    _nextQuestion();
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
        actions: [],
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

          const SizedBox(height: 80),
          const Text(
            'Which note is higher?',
            style: TextStyle(fontSize: 25, color: Colors.white70),
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
                    onPressed: _chooseLeft,
                  ),
                  Transform.rotate(angle: -math.pi / 120),
                  ArrowButton(
                    arrowIcon: 'assets/icons/arrow_right.svg',
                    onPressed: _chooseRight,
                  ),
                ],
              ),
            ],
          ),
          QuizNavigationButton(
            navIcon: 'assets/icons/arrow_right.svg',
            label: 'rawr',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
