class Achievements {
  final String id;
  final String title;
  final String description;
  bool isUnlocked;

  Achievements({
    required this.id,
    required this.title,
    required this.description,
    this.isUnlocked = false,
  });
}
