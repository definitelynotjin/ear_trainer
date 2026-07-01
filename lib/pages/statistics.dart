import 'package:audioplayers/audioplayers.dart';
import 'package:ear_trainer/models/quiz_session.dart';
import 'package:ear_trainer/widgets/app_background.dart';
import 'package:flutter/material.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  static const _accent = Color(0xFF00B8A9);
  final _session = QuizSession();
  List<Map<String, dynamic>> _history = [];
  bool _loading = true;

  static const _exercises = ['pitch', 'interval', 'scale'];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final h = await _session.getHistory();
    setState(() {
      _history = h;
      _loading = false;
    });
  }

  int _correctFor(String ex) => _history
      .where((r) => r['exercise'] == ex && (r['correct'] as int) == 1)
      .length;
  int _totalFor(String ex) => _history.where((r) => r['exercise'] == ex).length;

  List<Map<String, dynamic>> _rowsFor(String ex) =>
      _history.where((r) => r['exercise'] == ex).toList()..sort(
        (a, b) => (b['answered_at'] as int).compareTo(a['answered_at'] as int),
      );

  void _openDetail(String ex) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _ExerciseDetailPage(exercise: ex, rows: _rowsFor(ex)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: Color(0xFF0F3460),
        body: Center(child: CircularProgressIndicator(color: _accent)),
      );
    }
    final totalAnswers = _history.length;
    final totalCorrect = _history
        .where((r) => (r['correct'] as int) == 1)
        .length;
    final accuracy = totalAnswers == 0
        ? 0.0
        : (totalCorrect / totalAnswers * 100);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF0F3460),
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          'Statistics',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                const Text(
                  'Your Progress',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _BigStat(
                  label: 'Overall Accuracy',
                  value: accuracy.toStringAsFixed(1) + '%',
                  sub: '$totalCorrect / $totalAnswers correct',
                  color: _accent,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Per Exercise',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                ..._exercises.map((ex) {
                  final correct = _correctFor(ex);
                  final total = _totalFor(ex);
                  final pct = total == 0 ? 0.0 : (correct / total * 100);
                  return _ExerciseStat(
                    name: ex[0].toUpperCase() + ex.substring(1),
                    correct: correct,
                    total: total,
                    pct: pct,
                    onTap: total > 0 ? () => _openDetail(ex) : null,
                  );
                }),
                const SizedBox(height: 16),
                Text(
                  'Tap an exercise to review your answers',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.4),
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 24),
                if (_history.isNotEmpty) ...[
                  const Text(
                    'Recent Activity',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ..._history.take(10).map((r) {
                    final ex = (r['exercise'] as String);
                    final correct = (r['correct'] as int) == 1;
                    final dt = DateTime.fromMillisecondsSinceEpoch(
                      r['answered_at'] as int,
                    );
                    return ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        correct ? Icons.check_circle : Icons.cancel,
                        color: correct ? Colors.green : Colors.red,
                        size: 20,
                      ),
                      title: Text(
                        '${ex[0].toUpperCase()}${ex.substring(1)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      subtitle: Text(
                        '${dt.day}/${dt.month} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.4),
                          fontSize: 11,
                        ),
                      ),
                    );
                  }),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Detail page showing per-question evaluation for one exercise.
class _ExerciseDetailPage extends StatelessWidget {
  final String exercise;
  final List<Map<String, dynamic>> rows;

  const _ExerciseDetailPage({required this.exercise, required this.rows});

  static const _accent = Color(0xFF00B8A9);

  @override
  Widget build(BuildContext context) {
    final correct = rows.where((r) => (r['correct'] as int) == 1).length;
    final total = rows.length;
    final pct = total == 0 ? 0.0 : (correct / total * 100);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF0F3460),
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          '${exercise[0].toUpperCase()}${exercise.substring(1)} — Review',
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                _BigStat(
                  label: 'Accuracy',
                  value: '${pct.toStringAsFixed(1)}%',
                  sub: '$correct / $total correct',
                  color: _accent,
                ),
                const SizedBox(height: 24),
                Text(
                  'Answer Breakdown',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                ...rows.asMap().entries.map((entry) {
                  final i = entry.key + 1;
                  final r = entry.value;
                  final isCorrect = (r['correct'] as int) == 1;
                  final dt = DateTime.fromMillisecondsSinceEpoch(
                    r['answered_at'] as int,
                  );
                  final chosen = (r['chosen_answer'] as String?) ?? '—';
                  final correctAns = (r['correct_answer'] as String?) ?? '—';

                  return _AnswerCard(
                    index: i,
                    isCorrect: isCorrect,
                    chosen: chosen,
                    correctAnswer: correctAns,
                    dateTime: dt,
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AnswerCard extends StatefulWidget {
  final int index;
  final bool isCorrect;
  final String chosen;
  final String correctAnswer;
  final DateTime dateTime;

  const _AnswerCard({
    required this.index,
    required this.isCorrect,
    required this.chosen,
    required this.correctAnswer,
    required this.dateTime,
  });

  @override
  State<_AnswerCard> createState() => _AnswerCardState();
}

class _AnswerCardState extends State<_AnswerCard> {
  static final _player = AudioPlayer();

  /// Try play a note asset from a label like "C4 (L)" or "3 notes".
  /// Only plays if label starts with a note pattern like C4, D#4, etc.
  Future<void> _tryPlay(String label) async {
    final m = RegExp(r'^([A-G]#?\d)').firstMatch(label);
    if (m == null) return; // no note asset for interval/scale-only labels
    final asset = 'audio/${m.group(1)}.wav';
    try {
      await _player.stop();
      await _player.play(AssetSource(asset));
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.isCorrect ? Colors.green : Colors.red;
    // Detect if labels have a playable note prefix.
    final chosenPlayable = RegExp(r'^([A-G]#?\d)').hasMatch(widget.chosen);
    final correctPlayable = RegExp(
      r'^([A-G]#?\d)',
    ).hasMatch(widget.correctAnswer);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.4), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              widget.isCorrect ? Icons.check : Icons.close,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Q${widget.index}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${widget.dateTime.day}/${widget.dateTime.month} '
                      '${widget.dateTime.hour}:${widget.dateTime.minute.toString().padLeft(2, '0')}',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.4),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _PlayRow(
                  label: 'You chose',
                  value: widget.chosen,
                  valueColor: widget.isCorrect ? Colors.green : Colors.red,
                  playable: chosenPlayable,
                  onPlay: () => _tryPlay(widget.chosen),
                ),
                const SizedBox(height: 4),
                _PlayRow(
                  label: 'Correct',
                  value: widget.correctAnswer,
                  valueColor: Colors.green,
                  playable: correctPlayable,
                  onPlay: () => _tryPlay(widget.correctAnswer),
                ),
                if (!widget.isCorrect &&
                    widget.chosen != widget.correctAnswer) ...[
                  const SizedBox(height: 6),
                  Text(
                    'You picked the wrong answer',
                    style: TextStyle(
                      color: Colors.red.withValues(alpha: 0.7),
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Row with label + value + optional play button.
class _PlayRow extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;
  final bool playable;
  final VoidCallback? onPlay;

  const _PlayRow({
    required this.label,
    required this.value,
    required this.valueColor,
    this.playable = false,
    this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 12),
              children: [
                TextSpan(
                  text: '$label: ',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
                ),
                TextSpan(
                  text: value,
                  style: TextStyle(
                    color: valueColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (playable) ...[
          const SizedBox(width: 6),
          InkWell(
            onTap: onPlay,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: valueColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.volume_up, size: 12, color: valueColor),
            ),
          ),
        ],
      ],
    );
  }
}

class _LabeledText extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _LabeledText({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 12),
        children: [
          TextSpan(
            text: '$label: ',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
          ),
          TextSpan(
            text: value,
            style: TextStyle(color: valueColor, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _BigStat extends StatelessWidget {
  final String label;
  final String value;
  final String sub;
  final Color color;
  const _BigStat({
    required this.label,
    required this.value,
    required this.sub,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            sub,
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

class _ExerciseStat extends StatelessWidget {
  final String name;
  final int correct;
  final int total;
  final double pct;
  final VoidCallback? onTap;
  const _ExerciseStat({
    required this.name,
    required this.correct,
    required this.total,
    required this.pct,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    if (onTap != null) ...[
                      const SizedBox(width: 6),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.white.withValues(alpha: 0.4),
                        size: 16,
                      ),
                    ],
                  ],
                ),
                Text(
                  total == 0
                      ? '—'
                      : '$correct/$total (${pct.toStringAsFixed(0)}%)',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: total == 0 ? 0 : (correct / total),
                minHeight: 6,
                backgroundColor: Colors.white.withValues(alpha: 0.1),
                color: const Color(0xFF00B8A9),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
