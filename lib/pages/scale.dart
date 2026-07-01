import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:ear_trainer/models/note.dart';
import 'package:ear_trainer/models/achievements.dart';
import 'package:ear_trainer/models/quiz_session.dart';
import 'package:ear_trainer/widgets/choice_button.dart';
import 'package:ear_trainer/widgets/help.dart';
import 'package:ear_trainer/widgets/feedback_popup.dart';
import 'package:ear_trainer/widgets/app_background.dart';
import 'package:ear_trainer/widgets/pagebar.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Scale extends StatefulWidget {
  const Scale({super.key});

  @override
  State<Scale> createState() => _ScaleState();
}

class _ScaleState extends State<Scale> {
  static const _accent = Color(0xFFF8B400);
  static const _key = 'scale';
  final _rnd = Random();
  final AudioPlayer _player = AudioPlayer();
  final _session = QuizSession();
  static const Duration _highlightDuration = Duration(seconds: 5);

  late final List<Note> _cMajor;
  late int _missingIndex;
  late List<Note> _playable;
  late List<Note> _choices;
  int _highlightedPlayableIndex = -1;
  int _highlightedChoiceIndex = -1;
  int _previewedChoiceIndex = -1;
  bool _answered = false;
  Timer? _highlightResetTimer;
  Timer? _choiceHighlightResetTimer;

  @override
  void initState() {
    super.initState();
    Achievement.markExerciseUsed('scale');
    _cMajor = [
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
    _answered = false;
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
      return;
    }

    _answer(note);
  }

  Future<void> _answer(Note chosen) async {
    if (_answered) return;
    _answered = true;
    final correct = _cMajor[_missingIndex];
    final isCorrect =
        chosen.name == correct.name && chosen.octave == correct.octave;

    _session.recordAnswer(_key, isCorrect);
    final scoreCount = _session.getScore(_key);
    final streakCount = _session.getStreak(_key);
    final questionCount = _session.getQuestion(_key);
    setState(() {
      _previewedChoiceIndex = -1;
    });

    String? unlocked;
    if (questionCount >= 10 && scoreCount >= 10) {
      unlocked = await Achievement.unlock('flawless');
    }
    if (unlocked != null && mounted) {
      await FeedbackPopup.achievement(context, title: '$unlocked unlocked!');
    }

    if (!mounted) return;
    isCorrect
        ? FeedbackPopup.success(context)
        : FeedbackPopup.error(
            context,
            title: 'Wrong — Correct: ${correct.name}${correct.octave}',
          );

    if (questionCount >= 10) {
      Future.delayed(const Duration(milliseconds: 1400), () {
        if (mounted) _showComplete(context, questionCount, scoreCount);
      });
    } else {
      Future.delayed(const Duration(milliseconds: 700), _newQuestion);
    }
  }

  void _showComplete(BuildContext context, int total, int score) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: _accent.withValues(alpha: 0.5), width: 1),
        ),
        title: Icon(
          score >= 8 ? Icons.emoji_events : Icons.check_circle,
          color: score >= 8 ? Colors.amber : _accent,
          size: 48,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Training Complete!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You scored $score out of $total',
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              score >= 8
                  ? 'Excellent work!'
                  : score >= 5
                  ? 'Good effort!'
                  : 'Keep practicing!',
              style: TextStyle(
                color: _accent.withValues(alpha: 0.8),
                fontSize: 13,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(foregroundColor: _accent),
            onPressed: () async {
              await _session.reset(_key);
              if (!mounted) return;
              Navigator.pop(ctx);
              _newQuestion();
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _highlightResetTimer?.cancel();
    _choiceHighlightResetTimer?.cancel();
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
        title: const Text('Scale'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Help(
              helpIcon: 'assets/icons/help.svg',
              size: 25,
              pageId: 'scale',
              title: 'How to Play: Scale',
              content:
                  '1. Listen to the scale\nTap the note buttons at the top to hear the notes of the C Major scale. One note has been removed!\n\n'
                  '2. Find the missing note\nListen carefully to the gaps in the scale. Which note is missing?\n\n'
                  '3. Make your choice\nTap a choice button at the bottom once to preview its sound. Tap the exact same button a SECOND time to submit it as your final answer.\n\n'
                  'Tip: Tap any note button again to replay its sound as many times as you need.',
            ),
          ),
        ],
      ),
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                const SizedBox(height: 32),
                Text(
                  'Guess the missing note',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Low',
                      style: TextStyle(
                        color: _accent.withValues(alpha: 0.5),
                        fontSize: 11,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Ascending',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.4),
                            fontSize: 11,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward,
                          size: 14,
                          color: _accent.withValues(alpha: 0.5),
                        ),
                      ],
                    ),
                    Text(
                      'High',
                      style: TextStyle(
                        color: _accent.withValues(alpha: 0.5),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Playable notes (tap to hear):',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _playable.asMap().entries.map((entry) {
                      final index = entry.key;
                      final n = entry.value;
                      final isHighlighted = _highlightedPlayableIndex == index;

                      return Padding(
                        padding: EdgeInsets.only(
                          right: index < _playable.length - 1 ? 8 : 0,
                        ),
                        child: GestureDetector(
                          onTap: () => _playPlayable(n, index),
                          child: Container(
                            width: 42,
                            height: 60,
                            decoration: BoxDecoration(
                              color: isHighlighted
                                  ? _accent.withValues(alpha: 0.18)
                                  : Colors.white.withValues(alpha: 0.06),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isHighlighted
                                    ? _accent
                                    : Colors.white.withValues(alpha: 0.15),
                                width: 1,
                              ),
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                'assets/icons/waves.svg',
                                width: 22,
                                height: 22,
                                fit: BoxFit.contain,
                                colorFilter: ColorFilter.mode(
                                  isHighlighted ? _accent : Colors.white60,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Which note is missing?',
                  style: TextStyle(color: Colors.white, fontSize: 16),
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
                      width: 160,
                      height: 72,
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
