import '../database/database_helper.dart';
import '../models/user.dart';
import '../models/transaction.dart';
import '../models/category.dart';
import '../services/auth_service.dart';

class TestDataInitializer {
  static Future<void> initializeTestData() async {
    try {
      // 检查是否已经有测试用户
      final existingUser = await DatabaseHelper().getUserByUsername('zhanxiao');
      if (existingUser != null) {
        return; // 用户已存在，不需要初始化
      }

      // 创建测试用户
      final testUser = User(
        username: 'zhanxiao',
        email: 'zhanxiao@test.com',
        password: AuthService.hashPassword('123456'),
        initialBalance: 1000.0, // 设置期初余额
        createdAt: DateTime.now(),
      );

      final userId = await DatabaseHelper().insertUser(testUser);
      print('Test user created with ID: $userId');

      // 添加一些测试交易数据
      final now = DateTime.now();
      final transactions = [
        Transaction(
          amount: 5000.0,
          category: 'Salary',
          type: 'income',
          note: 'Monthly salary',
          dateTime: DateTime(now.year, now.month, 1),
          userId: 'zhanxiao',
        ),
        Transaction(
          amount: 200.0,
          category: 'Food',
          type: 'expense',
          note: 'Grocery shopping',
          dateTime: DateTime(now.year, now.month, 2),
          userId: 'zhanxiao',
        ),
        Transaction(
          amount: 50.0,
          category: 'Transportation',
          type: 'expense',
          note: 'Bus fare',
          dateTime: DateTime(now.year, now.month, 3),
          userId: 'zhanxiao',
        ),
        Transaction(
          amount: 100.0,
          category: 'Entertainment',
          type: 'expense',
          note: 'Movie tickets',
          dateTime: DateTime(now.year, now.month, 4),
          userId: 'zhanxiao',
        ),
        Transaction(
          amount: 300.0,
          category: 'Shopping',
          type: 'expense',
          note: 'Clothes shopping',
          dateTime: DateTime(now.year, now.month, 5),
          userId: 'zhanxiao',
        ),
        Transaction(
          amount: 1000.0,
          category: 'Bonus',
          type: 'income',
          note: 'Performance bonus',
          dateTime: DateTime(now.year, now.month, 10),
          userId: 'zhanxiao',
        ),
      ];

      for (final transaction in transactions) {
        await DatabaseHelper().insertTransaction(transaction);
      }

      print('Test data initialized successfully');
    } catch (e) {
      print('Error initializing test data: $e');
    }
  }
}
