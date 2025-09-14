class User {
  final int? id;
  final String username;
  final String email;
  final String password;
  final double initialBalance;
  final DateTime createdAt;

  User({
    this.id,
    required this.username,
    required this.email,
    required this.password,
    this.initialBalance = 0.0,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
      'initialBalance': initialBalance,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      email: map['email'],
      password: map['password'],
      initialBalance: map['initialBalance']?.toDouble() ?? 0.0,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }

  User copyWith({
    int? id,
    String? username,
    String? email,
    String? password,
    double? initialBalance,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      initialBalance: initialBalance ?? this.initialBalance,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
