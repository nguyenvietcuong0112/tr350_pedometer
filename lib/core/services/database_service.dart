import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../constants.dart';
import '../models/user_profile.dart';
import '../models/step_record.dart';
import '../models/run_record.dart';
import '../models/meal_record.dart';
import '../models/activity_record.dart';

class DatabaseService {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, AppConstants.databaseName);

    return await openDatabase(
      path,
      version: AppConstants.databaseVersion,
      onCreate: _onCreate,
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL DEFAULT 'Name',
        age INTEGER NOT NULL DEFAULT 26,
        height REAL NOT NULL DEFAULT 170.0,
        weight REAL NOT NULL DEFAULT 70.0,
        target_weight REAL NOT NULL DEFAULT 65.0,
        gender TEXT NOT NULL DEFAULT 'male',
        step_goal INTEGER NOT NULL DEFAULT 10000,
        daily_calorie_target INTEGER NOT NULL DEFAULT 2000
      )
    ''');

    await db.execute('''
      CREATE TABLE steps (
        date TEXT PRIMARY KEY,
        step_count INTEGER NOT NULL DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE runs (
        id TEXT PRIMARY KEY,
        date TEXT NOT NULL,
        distance REAL NOT NULL DEFAULT 0,
        duration INTEGER NOT NULL DEFAULT 0,
        calories REAL NOT NULL DEFAULT 0,
        route_data TEXT DEFAULT '',
        avg_pace REAL NOT NULL DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE meals (
        id TEXT PRIMARY KEY,
        date TEXT NOT NULL,
        meal_type TEXT NOT NULL,
        name TEXT NOT NULL,
        calories INTEGER NOT NULL DEFAULT 0,
        weight_grams REAL NOT NULL DEFAULT 100.0,
        image_url TEXT,
        protein REAL NOT NULL DEFAULT 0,
        carbs REAL NOT NULL DEFAULT 0,
        fat REAL NOT NULL DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE activities (
        id TEXT PRIMARY KEY,
        type TEXT NOT NULL,
        date TEXT NOT NULL,
        start_time TEXT NOT NULL,
        duration INTEGER NOT NULL DEFAULT 0,
        calories REAL NOT NULL DEFAULT 0,
        distance REAL NOT NULL DEFAULT 0
      )
    ''');

    // Insert default user profile
    await db.insert('users', const UserProfile().toMap());
  }

  // --- User Profile ---
  static Future<UserProfile> getUserProfile() async {
    final db = await database;
    final maps = await db.query('users', limit: 1);
    if (maps.isNotEmpty) {
      return UserProfile.fromMap(maps.first);
    }
    final defaultProfile = const UserProfile();
    await db.insert('users', defaultProfile.toMap());
    return defaultProfile;
  }

  static Future<void> updateUserProfile(UserProfile profile) async {
    final db = await database;
    if (profile.id != null) {
      await db.update('users', profile.toMap(),
          where: 'id = ?', whereArgs: [profile.id]);
    } else {
      await db.update('users', profile.toMap());
    }
  }

  // --- Steps ---
  static Future<StepRecord?> getStepRecord(String date) async {
    final db = await database;
    final maps = await db.query('steps', where: 'date = ?', whereArgs: [date]);
    if (maps.isNotEmpty) {
      return StepRecord.fromMap(maps.first);
    }
    return null;
  }

  static Future<void> upsertStepRecord(StepRecord record) async {
    final db = await database;
    await db.insert('steps', record.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<StepRecord>> getStepRecords(String fromDate, String toDate) async {
    final db = await database;
    final maps = await db.query('steps',
        where: 'date >= ? AND date <= ?',
        whereArgs: [fromDate, toDate],
        orderBy: 'date ASC');
    return maps.map((m) => StepRecord.fromMap(m)).toList();
  }

  // --- Runs ---
  static Future<void> insertRun(RunRecord run) async {
    final db = await database;
    await db.insert('runs', run.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<RunRecord>> getRunsByDate(String date) async {
    final db = await database;
    final maps = await db.query('runs',
        where: 'date = ?', whereArgs: [date], orderBy: 'id DESC');
    return maps.map((m) => RunRecord.fromMap(m)).toList();
  }

  static Future<List<RunRecord>> getRecentRuns({int limit = 20}) async {
    final db = await database;
    final maps = await db.query('runs', orderBy: 'date DESC', limit: limit);
    return maps.map((m) => RunRecord.fromMap(m)).toList();
  }

  static Future<void> deleteRun(String id) async {
    final db = await database;
    await db.delete('runs', where: 'id = ?', whereArgs: [id]);
  }

  // --- Meals ---
  static Future<void> insertMeal(MealRecord meal) async {
    final db = await database;
    await db.insert('meals', meal.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<MealRecord>> getMealsByDate(String date) async {
    final db = await database;
    final maps = await db.query('meals',
        where: 'date = ?', whereArgs: [date], orderBy: 'meal_type ASC');
    return maps.map((m) => MealRecord.fromMap(m)).toList();
  }

  static Future<void> updateMeal(MealRecord meal) async {
    final db = await database;
    await db.update('meals', meal.toMap(),
        where: 'id = ?', whereArgs: [meal.id]);
  }

  static Future<void> deleteMeal(String id) async {
    final db = await database;
    await db.delete('meals', where: 'id = ?', whereArgs: [id]);
  }

  // --- Aggregate ---
  static Future<int> getTotalCaloriesConsumed(String date) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COALESCE(SUM(calories), 0) as total FROM meals WHERE date = ?',
      [date],
    );
    return (result.first['total'] as num).toInt();
  }

  static Future<double> getTotalCaloriesBurnedFromRuns(String date) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COALESCE(SUM(calories), 0) as total FROM runs WHERE date = ?',
      [date],
    );
    return (result.first['total'] as num).toDouble();
  }

  // --- Activities ---
  static Future<void> insertActivity(ActivityRecord activity) async {
    final db = await database;
    await db.insert('activities', activity.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<ActivityRecord>> getActivitiesByDate(String date) async {
    final db = await database;
    final maps = await db.query('activities',
        where: 'date = ?', whereArgs: [date], orderBy: 'start_time DESC');
    return maps.map((m) => ActivityRecord.fromMap(m)).toList();
  }

  static Future<void> deleteActivity(String id) async {
    final db = await database;
    await db.delete('activities', where: 'id = ?', whereArgs: [id]);
  }

  static Future<double> getTotalActivityCalories(String date) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COALESCE(SUM(calories), 0) as total FROM activities WHERE date = ?',
      [date],
    );
    return (result.first['total'] as num).toDouble();
  }

  static Future<double> getTotalActivityDistance(String date) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COALESCE(SUM(distance), 0) as total FROM activities WHERE date = ?',
      [date],
    );
    return (result.first['total'] as num).toDouble();
  }

  static Future<int> getTotalActivityDuration(String date) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COALESCE(SUM(duration), 0) as total FROM activities WHERE date = ?',
      [date],
    );
    return (result.first['total'] as num).toInt();
  }
}
