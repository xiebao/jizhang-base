import 'package:sqflite/sqflite.dart' hide Transaction;
import 'package:path/path.dart';
import '../models/transaction.dart';
import '../models/user.dart';
import '../models/category.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'xmoney_note.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Users table
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        initialBalance REAL DEFAULT 0.0,
        createdAt INTEGER NOT NULL
      )
    ''');

    // Categories table
    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        type TEXT NOT NULL,
        userId TEXT NOT NULL,
        createdAt INTEGER NOT NULL
      )
    ''');

    // Transactions table
    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        amount REAL NOT NULL,
        category TEXT NOT NULL,
        type TEXT NOT NULL,
        note TEXT,
        dateTime INTEGER NOT NULL,
        userId TEXT NOT NULL
      )
    ''');

    // Insert default categories
    await _insertDefaultCategories(db);
  }

  Future<void> _insertDefaultCategories(Database db) async {
    final defaultCategories = [
      {'name': 'Default Income', 'type': 'income'},
      {'name': 'Default Expense', 'type': 'expense'},
      {'name': 'Food', 'type': 'expense'},
      {'name': 'Transportation', 'type': 'expense'},
      {'name': 'Entertainment', 'type': 'expense'},
      {'name': 'Shopping', 'type': 'expense'},
      {'name': 'Salary', 'type': 'income'},
      {'name': 'Bonus', 'type': 'income'},
      {'name': 'Investment', 'type': 'income'},
    ];

    for (var category in defaultCategories) {
      await db.insert('categories', {
        'name': category['name'],
        'type': category['type'],
        'userId': 'default',
        'createdAt': DateTime.now().millisecondsSinceEpoch,
      });
    }
  }

  // User operations
  Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  Future<User?> getUserByUsername(String username) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<User?> getUserByEmail(String email) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateUserInitialBalance(String username, double initialBalance) async {
    final db = await database;
    return await db.update(
      'users',
      {'initialBalance': initialBalance},
      where: 'username = ?',
      whereArgs: [username],
    );
  }

  // Category operations
  Future<int> insertCategory(Category category) async {
    final db = await database;
    return await db.insert('categories', category.toMap());
  }

  Future<List<Category>> getCategoriesByUser(String userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'categories',
      where: 'userId = ? OR userId = ?',
      whereArgs: [userId, 'default'],
      orderBy: 'name ASC',
    );
    return List.generate(maps.length, (i) => Category.fromMap(maps[i]));
  }

  Future<List<Category>> getCategoriesByType(String userId, String type) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'categories',
      where: '(userId = ? OR userId = ?) AND type = ?',
      whereArgs: [userId, 'default', type],
      orderBy: 'name ASC',
    );
    return List.generate(maps.length, (i) => Category.fromMap(maps[i]));
  }

  Future<int> deleteCategory(int id) async {
    final db = await database;
    return await db.delete(
      'categories',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Transaction operations
  Future<int> insertTransaction(Transaction transaction) async {
    final db = await database;
    return await db.insert('transactions', transaction.toMap());
  }

  Future<List<Transaction>> getTransactionsByUser(String userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'dateTime DESC',
    );
    return List.generate(maps.length, (i) => Transaction.fromMap(maps[i]));
  }

  Future<List<Transaction>> getTransactionsByDateRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      where: 'userId = ? AND dateTime >= ? AND dateTime <= ?',
      whereArgs: [
        userId,
        startDate.millisecondsSinceEpoch,
        endDate.millisecondsSinceEpoch,
      ],
      orderBy: 'dateTime DESC',
    );
    return List.generate(maps.length, (i) => Transaction.fromMap(maps[i]));
  }

  Future<double> getTotalIncome(String userId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT SUM(amount) as total FROM transactions WHERE userId = ? AND type = ?',
      [userId, 'income'],
    );
    return result.first['total'] as double? ?? 0.0;
  }

  Future<double> getTotalExpense(String userId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT SUM(amount) as total FROM transactions WHERE userId = ? AND type = ?',
      [userId, 'expense'],
    );
    return result.first['total'] as double? ?? 0.0;
  }

  Future<int> getTransactionCount(String userId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM transactions WHERE userId = ?',
      [userId],
    );
    return result.first['count'] as int? ?? 0;
  }

  Future<int> deleteTransaction(int id) async {
    final db = await database;
    return await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> updateTransaction(Transaction transaction) async {
    final db = await database;
    return await db.update(
      'transactions',
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }
}
