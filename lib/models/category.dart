class Category {
  final int? id;
  final String name;
  final String type; // 'income' or 'expense'
  final String userId;
  final DateTime createdAt;

  Category({
    this.id,
    required this.name,
    required this.type,
    required this.userId,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'userId': userId,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
      type: map['type'],
      userId: map['userId'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }

  Category copyWith({
    int? id,
    String? name,
    String? type,
    String? userId,
    DateTime? createdAt,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
