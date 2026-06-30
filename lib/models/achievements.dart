import 'package:ear_trainer/models/quiz_session.dart';

class Achievement {
  final String id;
  final String title;
  final String description;
  final String icon;
  bool isUnlocked;

  static final Set<String> _completedExercises = <String>{};

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    this.isUnlocked = false,
  });

  static final List<Achievement> all = [
    Achievement(
      id: 'first_note',
      title: 'First Note',
      description: 'Get your first correct answer in Pitch.',
      icon: 'assets/badges/badge_first_note.svg',
    ),
    Achievement(
      id: 'perfect_pitch',
      title: 'Perfect Pitch',
      description: 'Get 5 correct answers in a row in Pitch.',
      icon: 'assets/badges/badge_perfect_pitch.svg',
    ),
    Achievement(
      id: 'pitch_veteran',
      title: 'Pitch Veteran',
      description: 'Complete 10 questions in Pitch.',
      icon: 'assets/badges/badge_pitch_veteran.svg',
    ),
    Achievement(
      id: 'ear_opening',
      title: 'Ear Opening',
      description: 'Get your first correct answer in Interval.',
      icon: 'assets/badges/badge_ear_opening.svg',
    ),
    Achievement(
      id: 'interval_instinct',
      title: 'Interval Instinct',
      description: 'Get 3 correct answers in a row in Interval.',
      icon: 'assets/badges/badge_interval_instinct.svg',
    ),
    Achievement(
      id: 'all_rounder',
      title: 'All Rounder',
      description: 'Try all 3 exercises at least once.',
      icon: 'assets/badges/badge_all_rounder.svg',
    ),
    Achievement(
      id: 'flawless',
      title: 'Flawless',
      description: 'Get a perfect score in one session (10/10).',
      icon: 'assets/badges/badge_flawless.svg',
    ),
    Achievement(
      id: 'completionist',
      title: 'Completionist',
      description: 'Unlock every available badge',
      icon: 'assets/badges/badge_completionist.svg',
    ),
  ];

  static Achievement? _findById(String id) {
    for (final achievement in all) {
      if (achievement.id == id) {
        return achievement;
      }
    }
    return null;
  }

  static Future<void> loadState() async {
    final db = await QuizSession().database();

    // Load achievements
    final achRows = await db.query('achievements');
    final unlockedIds = <String>{};
    for (final r in achRows) {
      if ((r['unlocked'] as int) == 1) {
        unlockedIds.add(r['id'] as String);
      }
    }
    for (final achievement in all) {
      achievement.isUnlocked = unlockedIds.contains(achievement.id);
    }

    // Load exercises
    final exRows = await db.query('exercises');
    _completedExercises
      ..clear()
      ..addAll(
        exRows
            .where((r) => (r['used'] as int) == 1)
            .map((r) => r['id'] as String),
      );
  }

  static Future<void> _saveUnlocked() async {
    final db = await QuizSession().database();
    final batch = db.batch();
    // Clear + reinsert unlocked
    batch.delete('achievements');
    for (final a in all.where((a) => a.isUnlocked)) {
      batch.insert('achievements', {'id': a.id, 'unlocked': 1});
    }
    await batch.commit(noResult: true);
  }

  static Future<void> _saveExercises() async {
    final db = await QuizSession().database();
    final batch = db.batch();
    batch.delete('exercises');
    for (final e in _completedExercises) {
      batch.insert('exercises', {'id': e, 'used': 1});
    }
    await batch.commit(noResult: true);
  }

  static Future<void> resetAll() async {
    final db = await QuizSession().database();
    for (final achievement in all) {
      achievement.isUnlocked = false;
    }
    _completedExercises.clear();
    await db.delete('achievements');
    await db.delete('exercises');
  }

  static Future<void> unlockAll() async {
    for (final achievement in all) {
      achievement.isUnlocked = true;
    }
    await _saveUnlocked();
  }

  static Future<void> unlock(String id) async {
    final achievement = _findById(id);
    if (achievement != null) {
      achievement.isUnlocked = true;
      await _saveUnlocked();
      // Check completionist
      if (all.every((a) => a.isUnlocked) &&
          _findById('completionist') != null) {
        final c = _findById('completionist')!;
        if (!c.isUnlocked) {
          c.isUnlocked = true;
          await _saveUnlocked();
        }
      }
    }
  }

  static Future<void> markExerciseUsed(String exerciseId) async {
    _completedExercises.add(exerciseId);
    if (_completedExercises.contains('pitch') &&
        _completedExercises.contains('interval') &&
        _completedExercises.contains('scale')) {
      await unlock('all_rounder');
      return;
    }
    await _saveExercises();
  }
}
