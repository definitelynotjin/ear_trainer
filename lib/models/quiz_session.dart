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
      version: 4,
      onCreate: (db, v) async {
        await _createAllTables(db);
      },
      onUpgrade: (db, oldV, newV) async {
        await _createAllTables(db);
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
        last_correct INTEGER
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
        answered_at INTEGER NOT NULL
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
      );
    }
    _loaded = true;
  }

  _ExerciseState _get(String key) {
    _cache.putIfAbsent(key, () => _ExerciseState());
    return _cache[key]!;
  }

  Future<void> _persist(String key) async {
    final db = await _open();
    final s = _get(key);
    await db.insert('quiz_progress', {
      'exercise': key,
      'score': s.score,
      'streak': s.streak,
      'question': s.question,
      'last_correct': s.lastCorrect == null ? null : (s.lastCorrect! ? 1 : 0),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  int getScore(String key) => _get(key).score;
  int getStreak(String key) => _get(key).streak;
  int getQuestion(String key) => _get(key).question;
  bool? getLastCorrect(String key) => _get(key).lastCorrect;

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

  void recordAnswer(String key, bool correct) {
    final s = _get(key);
    s.question++;
    if (correct) {
      s.score++;
      s.streak++;
    } else {
      s.streak = 0;
    }
    s.lastCorrect = correct;
    _persist(key);
    _logHistory(key, correct);
  }

  Future<void> _logHistory(String exercise, bool correct) async {
    final db = await _open();
    await db.insert('answer_history', {
      'exercise': exercise,
      'correct': correct ? 1 : 0,
      'answered_at': DateTime.now().millisecondsSinceEpoch,
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
    _cache[key] = _ExerciseState();
    final db = await _open();
    await db.delete('quiz_progress', where: 'exercise = ?', whereArgs: [key]);
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
  bool? lastCorrect;

  _ExerciseState({
    this.score = 0,
    this.streak = 0,
    this.question = 0,
    this.lastCorrect,
  });
}
