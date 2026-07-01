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
                // Overall accuracy
                _BigStat(
                  label: 'Overall Accuracy',
                  value: accuracy.toStringAsFixed(1) + '%',
                  sub: '$totalCorrect / $totalAnswers correct',
                  color: _accent,
                ),
                const SizedBox(height: 24),
                // Per exercise
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
                  );
                }),
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
  const _ExerciseStat({
    required this.name,
    required this.correct,
    required this.total,
    required this.pct,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: const TextStyle(color: Colors.white, fontSize: 14),
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
    );
  }
}
