import 'package:shared_preferences/shared_preferences.dart';

class Achievement {
  final String id;
  final String title;
  final String description;
  final String icon;
  bool isUnlocked;

  static final Set<String> _completedExercises = <String>{};
  static const String _unlockedKey = 'achievement_unlocked_ids';
  static const String _completedExercisesKey =
      'achievement_completed_exercises';

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
    final prefs = await SharedPreferences.getInstance();
    final unlockedIds = prefs.getStringList(_unlockedKey) ?? <String>[];
    final completedExercises =
        prefs.getStringList(_completedExercisesKey) ?? <String>[];

    for (final achievement in all) {
      achievement.isUnlocked = unlockedIds.contains(achievement.id);
    }

    _completedExercises
      ..clear()
      ..addAll(completedExercises);
  }

  static Future<void> _saveState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _unlockedKey,
      all
          .where((achievement) => achievement.isUnlocked)
          .map((a) => a.id)
          .toList(),
    );
    await prefs.setStringList(
      _completedExercisesKey,
      _completedExercises.toList(),
    );
  }

  static Future<void> resetAll() async {
    final prefs = await SharedPreferences.getInstance();

    for (final achievement in all) {
      achievement.isUnlocked = false;
    }

    _completedExercises.clear();
    await prefs.remove(_unlockedKey);
    await prefs.remove(_completedExercisesKey);
  }

  static Future<void> unlock(String id) async {
    final achievement = _findById(id);
    if (achievement != null) {
      achievement.isUnlocked = true;
      await _saveState();
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

    await _saveState();
  }
}
