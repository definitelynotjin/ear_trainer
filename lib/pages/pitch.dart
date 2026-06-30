import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:ear_trainer/widgets/pagebar.dart';
import 'package:ear_trainer/widgets/note_button.dart';
import 'package:ear_trainer/widgets/arrow_button.dart';
import 'package:ear_trainer/widgets/help.dart';
import 'package:ear_trainer/models/note.dart';
import 'package:ear_trainer/models/achievements.dart';
import 'package:ear_trainer/widgets/feedback_popup.dart';
import 'package:ear_trainer/models/quiz_session.dart';
import 'package:ear_trainer/widgets/app_background.dart';
import 'dart:math' as math;

class Pitch extends StatefulWidget {
  const Pitch({super.key});

  @override
  State<Pitch> createState() => _PitchState();
}

class _PitchState extends State<Pitch> {
  static const _accent = Color(0xFFFF6B35);
  final _rnd = math.Random();
  final AudioPlayer _player = AudioPlayer();
  late Note leftNote;
  late Note rightNote;
  final _session = QuizSession();
  static const _key = 'pitch';
  bool _leftPlayed = false;
  bool _rightPlayed = false;
  bool _answered = false;
  bool get _canChoose => _leftPlayed && _rightPlayed && !_answered;

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
      _answered = false;
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
    if (_answered) return;
    _answered = true;
    final bool correct = leftChosen
        ? leftNote.frequency > rightNote.frequency
        : rightNote.frequency > leftNote.frequency;

    _session.recordAnswer(_key, correct);
    final scoreCount = _session.getScore(_key);
    final streakCount = _session.getStreak(_key);
    final questionCount = _session.getQuestion(_key);
    setState(() {});

    if (correct && scoreCount == 1) {
      Achievement.unlock('first_note');
    }
    if (streakCount >= 5) {
      Achievement.unlock('perfect_pitch');
    }
    if (questionCount >= 10) {
      Achievement.unlock('pitch_veteran');
      if (scoreCount >= 10) {
        Achievement.unlock('flawless');
      }
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
          'Pitch',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Help(
              helpIcon: 'assets/icons/help.svg',
              size: 25,
              pageId: 'pitch',
              title: 'Pitch Training',
              content:
                  '1. Listen to the notes\nTap both circle buttons to hear the two different notes.\n\n'
                  '2. Compare the pitch\nDecide which of the two notes sounds HIGHER.\n\n'
                  '3. Make your choice\nTap the LEFT arrow if the first note is higher, or tap the RIGHT arrow if the second note is higher.',
            ),
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: AppBackground(
        child: SafeArea(
          child: Padding(
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
                  'Which note is higher?',
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ArrowButton(
                      arrowIcon: 'assets/icons/arrow_left.svg',
                      size: 80,
                      onPressed: _canChoose
                          ? _chooseLeft
                          : () {
                              FeedbackPopup.info(
                                context,
                                title: 'Play both notes first',
                              );
                            },
                    ),
                    ArrowButton(
                      arrowIcon: 'assets/icons/arrow_right.svg',
                      size: 80,
                      onPressed: _canChoose
                          ? _chooseRight
                          : () {
                              FeedbackPopup.info(
                                context,
                                title: 'Play both notes first',
                              );
                            },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _chooseLeft() => _score(true);
  void _chooseRight() => _score(false);
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
