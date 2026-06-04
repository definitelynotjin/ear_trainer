class Achievement {
  final String id;
  final String title;
  final String description;
  final String icon;
  bool isUnlocked;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,

    this.isUnlocked = false,
  });

  static List<Achievement> get all => [
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
}
