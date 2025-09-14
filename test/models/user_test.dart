import 'package:flutter_test/flutter_test.dart';
import 'package:xmoney_note/models/user.dart';

void main() {
  group('User Model Tests', () {
    late User testUser;
    late DateTime testCreatedAt;

    setUp(() {
      testCreatedAt = DateTime(2024, 1, 1, 10, 0, 0);
      testUser = User(
        id: 1,
        username: 'testuser',
        email: 'test@example.com',
        password: 'hashedpassword',
        createdAt: testCreatedAt,
      );
    });

    test('should create User with all required properties', () {
      expect(testUser.id, equals(1));
      expect(testUser.username, equals('testuser'));
      expect(testUser.email, equals('test@example.com'));
      expect(testUser.password, equals('hashedpassword'));
      expect(testUser.createdAt, equals(testCreatedAt));
    });

    test('should serialize User to Map correctly', () {
      final map = testUser.toMap();
      
      expect(map['id'], equals(1));
      expect(map['username'], equals('testuser'));
      expect(map['email'], equals('test@example.com'));
      expect(map['password'], equals('hashedpassword'));
      expect(map['createdAt'], equals(testCreatedAt.millisecondsSinceEpoch));
    });

    test('should deserialize User from Map correctly', () {
      final map = {
        'id': 1,
        'username': 'testuser',
        'email': 'test@example.com',
        'password': 'hashedpassword',
        'createdAt': testCreatedAt.millisecondsSinceEpoch,
      };

      final user = User.fromMap(map);

      expect(user.id, equals(1));
      expect(user.username, equals('testuser'));
      expect(user.email, equals('test@example.com'));
      expect(user.password, equals('hashedpassword'));
      expect(user.createdAt, equals(testCreatedAt));
    });

    test('should create copy with updated properties', () {
      final updatedUser = testUser.copyWith(
        username: 'newusername',
        email: 'new@example.com',
      );

      expect(updatedUser.id, equals(1));
      expect(updatedUser.username, equals('newusername'));
      expect(updatedUser.email, equals('new@example.com'));
      expect(updatedUser.password, equals('hashedpassword'));
      expect(updatedUser.createdAt, equals(testCreatedAt));
    });
  });
}