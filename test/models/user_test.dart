import 'package:flutter_test/flutter_test.dart';
import 'package:kids_math_game/models/user.dart';

void main() {
  group('User Model Tests', () {
    late User testUser;
    late DateTime testCreatedAt;
    late DateTime testLastLoginAt;

    setUp(() {
      testCreatedAt = DateTime(2024, 1, 1, 10, 0, 0);
      testLastLoginAt = DateTime(2024, 1, 2, 15, 30, 0);
      testUser = User(
        id: 'user123',
        accountId: 'acc456',
        username: 'testchild',
        createdAt: testCreatedAt,
        lastLoginAt: testLastLoginAt,
      );
    });

    test('should create User with all required properties', () {
      expect(testUser.id, equals('user123'));
      expect(testUser.accountId, equals('acc456'));
      expect(testUser.username, equals('testchild'));
      expect(testUser.createdAt, equals(testCreatedAt));
      expect(testUser.lastLoginAt, equals(testLastLoginAt));
    });

    test('should serialize User to JSON correctly', () {
      final json = testUser.toJson();
      
      expect(json['id'], equals('user123'));
      expect(json['accountId'], equals('acc456'));
      expect(json['username'], equals('testchild'));
      expect(json['createdAt'], equals(testCreatedAt.toIso8601String()));
      expect(json['lastLoginAt'], equals(testLastLoginAt.toIso8601String()));
    });

    test('should deserialize User from JSON correctly', () {
      final json = {
        'id': 'user123',
        'accountId': 'acc456',
        'username': 'testchild',
        'createdAt': testCreatedAt.toIso8601String(),
        'lastLoginAt': testLastLoginAt.toIso8601String(),
      };

      final user = User.fromJson(json);

      expect(user.id, equals('user123'));
      expect(user.accountId, equals('acc456'));
      expect(user.username, equals('testchild'));
      expect(user.createdAt, equals(testCreatedAt));
      expect(user.lastLoginAt, equals(testLastLoginAt));
    });

    test('should create copy with updated properties', () {
      final newLastLogin = DateTime(2024, 1, 3, 12, 0, 0);
      final updatedUser = testUser.copyWith(
        username: 'newusername',
        lastLoginAt: newLastLogin,
      );

      expect(updatedUser.id, equals('user123'));
      expect(updatedUser.accountId, equals('acc456'));
      expect(updatedUser.username, equals('newusername'));
      expect(updatedUser.createdAt, equals(testCreatedAt));
      expect(updatedUser.lastLoginAt, equals(newLastLogin));
    });

    test('should implement equality correctly', () {
      final sameUser = User(
        id: 'user123',
        accountId: 'acc456',
        username: 'testchild',
        createdAt: testCreatedAt,
        lastLoginAt: testLastLoginAt,
      );

      final differentUser = User(
        id: 'user456',
        accountId: 'acc456',
        username: 'testchild',
        createdAt: testCreatedAt,
        lastLoginAt: testLastLoginAt,
      );

      expect(testUser, equals(sameUser));
      expect(testUser, isNot(equals(differentUser)));
    });

    test('should have consistent hashCode for equal objects', () {
      final sameUser = User(
        id: 'user123',
        accountId: 'acc456',
        username: 'testchild',
        createdAt: testCreatedAt,
        lastLoginAt: testLastLoginAt,
      );

      expect(testUser.hashCode, equals(sameUser.hashCode));
    });

    test('should have meaningful toString representation', () {
      final stringRepresentation = testUser.toString();
      
      expect(stringRepresentation, contains('user123'));
      expect(stringRepresentation, contains('acc456'));
      expect(stringRepresentation, contains('testchild'));
    });

    test('should handle JSON serialization round trip', () {
      final json = testUser.toJson();
      final deserializedUser = User.fromJson(json);
      
      expect(deserializedUser, equals(testUser));
    });
  });
}