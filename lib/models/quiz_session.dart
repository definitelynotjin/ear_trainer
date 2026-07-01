import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

/// Singleton holding quiz progress per exercise.
/// Persisted in SQLite (table: quiz_progress).
/// Survives app restart + Navigator push/pop.
class QuizSession {
  static final QuizSession _instance = QuizSession._internal();
  factory QuizSession() => _instance;
  QuizSession._internal();

  Database? _db;
  final Map<String, _ExerciseState> _cache = {};
  bool _loaded = false;

  Future<Database> database() => _open();

  Future<Database> _open() async {
    if (_db != null) return _db!;
    final dbPath = await getDatabasesPath();
    _db = await openDatabase(
      p.join(dbPath, 'ear_trainer.db'),
      version: 7,
      onCreate: (db, v) async {
        await _createAllTables(db);
      },
      onUpgrade: (db, oldV, newV) async {
        await _createAllTables(db);
        // Add lifetime column for upgrades from v4
        if (oldV < 5) {
          await db.execute(
            'ALTER TABLE quiz_progress ADD COLUMN lifetime INTEGER NOT NULL DEFAULT 0',
          );
        }
        // Add chosen/correct answer columns for upgrades from v5
        if (oldV < 6) {
          await db.execute(
            'ALTER TABLE answer_history ADD COLUMN chosen_answer TEXT',
          );
          await db.execute(
            'ALTER TABLE answer_history ADD COLUMN correct_answer TEXT',
          );
        }
        // Add lives column for upgrades from v6
        if (oldV < 7) {
          await db.execute(
            'ALTER TABLE quiz_progress ADD COLUMN lives INTEGER NOT NULL DEFAULT 3',
          );
        }
      },
    );
    return _db!;
  }

  static Future<void> _createAllTables(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS quiz_progress(
        exercise TEXT PRIMARY KEY,
        score INTEGER NOT NULL DEFAULT 0,
        streak INTEGER NOT NULL DEFAULT 0,
        question INTEGER NOT NULL DEFAULT 0,
        last_correct INTEGER,
        lifetime INTEGER NOT NULL DEFAULT 0,
        lives INTEGER NOT NULL DEFAULT 3
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS achievements(
        id TEXT PRIMARY KEY,
        unlocked INTEGER NOT NULL DEFAULT 0
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS exercises(
        id TEXT PRIMARY KEY,
        used INTEGER NOT NULL DEFAULT 0
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS seen_pages(
        page TEXT PRIMARY KEY,
        seen INTEGER NOT NULL DEFAULT 0
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS answer_history(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        exercise TEXT NOT NULL,
        correct INTEGER NOT NULL,
        answered_at INTEGER NOT NULL,
        chosen_answer TEXT,
        correct_answer TEXT
      )
    ''');
  }

  /// Load all rows into cache. Safe to call multiple times.
  Future<void> load() async {
    if (_loaded) return;
    final db = await _open();
    final rows = await db.query('quiz_progress');
    for (final r in rows) {
      final key = r['exercise'] as String;
      _cache[key] = _ExerciseState(
        score: r['score'] as int,
        streak: r['streak'] as int,
        question: r['question'] as int,
        lastCorrect: r['last_correct'] == null
            ? null
            : (r['last_correct'] as int) == 1,
        lifetime: (r['lifetime'] as int?) ?? 0,
        lives: (r['lives'] as int?) ?? 3,
      );
    }
    _loaded = true;
  }

  _ExerciseState _get(String key) {
    _cache.putIfAbsent(key, () => _ExerciseState());
    return _cache[key]!;
  }

  /// Lifetime answer count (never reset by round-level `reset`).
  /// Only cleared by `resetAll`. Sync, from cache.
  int getLifetime(String key) => _get(key).lifetime;

  /// Current consecutive wrong answers. Sync, from cache.
  int getWrongStreak(String key) => _get(key).wrongStreak;

  Future<void> _persist(String key) async {
    final db = await _open();
    final s = _get(key);
    await db.insert('quiz_progress', {
      'exercise': key,
      'score': s.score,
      'streak': s.streak,
      'question': s.question,
      'last_correct': s.lastCorrect == null ? null : (s.lastCorrect! ? 1 : 0),
      'lifetime': s.lifetime,
      'lives': s.lives,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  int getScore(String key) => _get(key).score;
  int getStreak(String key) => _get(key).streak;
  int getQuestion(String key) => _get(key).question;
  bool? getLastCorrect(String key) => _get(key).lastCorrect;
  int getLives(String key) => _get(key).lives;
  bool isDead(String key) => _get(key).lives <= 0;

  /// Refill lives to full for [key] (used when starting/restarting a round).
  void refillLives(String key) {
    _get(key).lives = 3;
    _persist(key);
  }

  /// Bulk-add lifetime answers (admin cheat for testing thank-you).
  void fillLifetime(String key, int count) {
    final s = _get(key);
    s.lifetime += count;
    _persist(key);
  }

  /// Force-set the question count for a key (admin cheat).
  void setQuestion(String key, int count) {
    final s = _get(key);
    s.question = count;
    _persist(key);
  }

  /// Returns true if this is the first time visiting [page].
  /// Marks it as seen. Use in initState of pages.
  Future<bool> isFirstVisit(String page) async {
    final db = await _open();
    final rows = await db.query(
      'seen_pages',
      where: 'page = ?',
      whereArgs: [page],
    );
    if (rows.isEmpty) {
      await db.insert('seen_pages', {'page': page, 'seen': 1});
      return true;
    }
    return false;
  }

  void recordAnswer(
    String key,
    bool correct, {
    String? chosenAnswer,
    String? correctAnswer,
  }) {
    final s = _get(key);
    s.question++;
    s.lifetime++;
    if (correct) {
      s.score++;
      s.streak++;
      s.wrongStreak = 0;
    } else {
      s.streak = 0;
      s.wrongStreak++;
      if (s.lives > 0) s.lives--;
    }
    s.lastCorrect = correct;
    _persist(key);
    _logHistory(key, correct, chosenAnswer, correctAnswer);
  }

  Future<void> _logHistory(
    String exercise,
    bool correct,
    String? chosenAnswer,
    String? correctAnswer,
  ) async {
    final db = await _open();
    await db.insert('answer_history', {
      'exercise': exercise,
      'correct': correct ? 1 : 0,
      'answered_at': DateTime.now().millisecondsSinceEpoch,
      'chosen_answer': chosenAnswer,
      'correct_answer': correctAnswer,
    });
  }

  /// Returns answer history rows (most recent first).
  /// Each row: {id, exercise, correct (int), answered_at (int ms)}
  Future<List<Map<String, dynamic>>> getHistory({
    String? exercise,
    int? limit,
  }) async {
    final db = await _open();
    final where = exercise != null ? 'exercise = ?' : null;
    final whereArgs = exercise != null ? [exercise] : null;
    final orderBy = 'answered_at DESC';
    final limitVal = limit;
    return db.query(
      'answer_history',
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
      limit: limitVal,
    );
  }

  /// Total answers across all exercises.
  Future<int> get totalAnswered async {
    final db = await _open();
    final rows = await db.rawQuery('SELECT COUNT(*) as c FROM answer_history');
    return Sqflite.firstIntValue(rows) ?? 0;
  }

  Future<void> reset(String key) async {
    // Preserve lifetime across round resets. Refill lives.
    final oldLifetime = _get(key).lifetime;
    _cache[key] = _ExerciseState(lifetime: oldLifetime, lives: 3);
    final db = await _open();
    await db.delete('quiz_progress', where: 'exercise = ?', whereArgs: [key]);
    _persist(key);
  }

  Future<void> resetAll() async {
    _cache.clear();
    final db = await _open();
    await db.delete('quiz_progress');
    await db.delete('answer_history');
  }
}

class _ExerciseState {
  int score;
  int streak;
  int question;
  int lifetime;
  int wrongStreak;
  int lives;
  bool? lastCorrect;

  _ExerciseState({
    this.score = 0,
    this.streak = 0,
    this.question = 0,
    this.lifetime = 0,
    this.wrongStreak = 0,
    this.lives = 3,
    this.lastCorrect,
  });
}
