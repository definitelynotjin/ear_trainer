import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:ear_trainer/widgets/pagebar.dart';
import 'package:ear_trainer/widgets/choice_button.dart';
import 'package:ear_trainer/widgets/note_button.dart';
import 'package:ear_trainer/models/note.dart';
import 'package:ear_trainer/models/achievements.dart';
import 'package:ear_trainer/widgets/help.dart';
import 'package:ear_trainer/widgets/feedback_popup.dart';
import 'package:ear_trainer/models/quiz_session.dart';
import 'package:ear_trainer/widgets/app_background.dart';

class Interval extends StatefulWidget {
  const Interval({super.key});

  @override
  State<Interval> createState() => _IntervalState();
}

class _IntervalState extends State<Interval> {
  static const _accent = Color(0xFF00B8A9);
  final _rnd = math.Random();
  final AudioPlayer _player = AudioPlayer();
  final _session = QuizSession();
  static const _key = 'interval';
  late Note leftNote;
  late Note rightNote;
  late int _correctDistance;
  late List<int> _choices;
  static const List<int> _possibleDistances = [2, 3, 4, 5, 7, 9, 11];
  bool _leftPlayed = false;
  bool _rightPlayed = false;
  bool _answered = false;
  bool get _canChoose => _leftPlayed && _rightPlayed && !_answered;

  @override
  void initState() {
    super.initState();
    Achievement.markExerciseUsed('interval');
    _nextQuestion();
  }

  void _nextQuestion() {
    int a = _rnd.nextInt(Note.notes.length);
    int b;
    do {
      b = _rnd.nextInt(Note.notes.length);
    } while (b == a);
    final int distance = (Note.notes[a].semitone - Note.notes[b].semitone)
        .abs();
    final List<int> wrongs =
        _possibleDistances.where((d) => d != distance).toList()..shuffle(_rnd);
    final List<int> choices = [distance, wrongs[0], wrongs[1], wrongs[2]]
      ..shuffle(_rnd);

    setState(() {
      leftNote = Note.notes[a];
      rightNote = Note.notes[b];
      _correctDistance = distance;
      _choices = choices;
      _leftPlayed = false;
      _rightPlayed = false;
      _answered = false;
    });
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

  void _choose(int distance) {
    if (!_canChoose) {
      FeedbackPopup.info(context, title: 'Play both notes first');
      return;
    }
    _answered = true;
    final bool correct = distance == _correctDistance;

    _session.recordAnswer(_key, correct);
    final scoreCount = _session.getScore(_key);
    final streakCount = _session.getStreak(_key);
    final questionCount = _session.getQuestion(_key);
    setState(() {});

    if (correct && scoreCount == 1) {
      Achievement.unlock('ear_opening');
    }
    if (streakCount >= 3) {
      Achievement.unlock('interval_instinct');
    }
    if (questionCount >= 10 && scoreCount >= 10) {
      Achievement.unlock('flawless');
    }

    correct ? FeedbackPopup.success(context) : FeedbackPopup.error(context);
    _nextQuestion();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Color get _progressColor {
    final last = _session.getLastCorrect(_key);
    if (last == null) return _accent;
    return last ? Colors.green : Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF0F3460),
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          'Interval',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Help(
              helpIcon: 'assets/icons/help.svg',
              size: 25,
              pageId: 'interval',
              title: 'Interval Training',
              content:
                  '1. Listen to the notes\nTap both circle buttons to hear the two different notes.\n\n'
                  '2. Calculate the distance\nListen closely to the gap between the two pitches. How many semitones (notes) apart are they?\n\n'
                  '3. Make your choice\nSelect the correct number from the grid below. Remember, you must listen to both notes first!',
            ),
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                const SizedBox(height: 60),
                StepProgressBar(
                  totalSteps: 10,
                  currentStep: (_session.getQuestion(_key) - 1).clamp(-1, 9),
                  activeColor: _progressColor,
                  onStepChanged: (i) => debugPrint('step $i'),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _Stat(
                      label: 'Score',
                      value: '${_session.getScore(_key)}',
                      color: _accent,
                    ),
                    _Stat(
                      label: 'Streak',
                      value: '${_session.getStreak(_key)}',
                      color: _accent,
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Text(
                  'How far apart are the notes?',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CircleNoteButton(
                      circleIcon: 'assets/icons/circle.svg',
                      soundAsset:
                          'audio/${leftNote.name}${leftNote.octave}.wav',
                      onPressed: () => _play(leftNote),
                    ),
                    CircleNoteButton(
                      circleIcon: 'assets/icons/circle.svg',
                      soundAsset:
                          'audio/${rightNote.name}${rightNote.octave}.wav',
                      onPressed: () => _play(rightNote),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 2.2,
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  children: _choices
                      .map(
                        (distance) => SizedBox(
                          width: double.infinity,
                          height: 70,
                          child: ChoiceButton(
                            answer: distance.toString(),
                            subtitle: 'notes apart',
                            onPressed: () => _choose(distance),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _Stat({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
