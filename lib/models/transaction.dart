class Transaction {
  final int? id;
  final double amount;
  final String category;
  final String type; // 'income' or 'expense'
  final String? note;
  final DateTime dateTime;
  final String userId;

  Transaction({
    this.id,
    required this.amount,
    required this.category,
    required this.type,
    this.note,
    required this.dateTime,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'category': category,
      'type': type,
      'note': note,
      'dateTime': dateTime.millisecondsSinceEpoch,
      'userId': userId,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      amount: map['amount'],
      category: map['category'],
      type: map['type'],
      note: map['note'],
      dateTime: DateTime.fromMillisecondsSinceEpoch(map['dateTime']),
      userId: map['userId'],
    );
  }

  Transaction copyWith({
    int? id,
    double? amount,
    String? category,
    String? type,
    String? note,
    DateTime? dateTime,
    String? userId,
  }) {
    return Transaction(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      type: type ?? this.type,
      note: note ?? this.note,
      dateTime: dateTime ?? this.dateTime,
      userId: userId ?? this.userId,
    );
  }
}
