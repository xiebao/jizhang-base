import "dart:math";

class User {
  final String nickname;
  final String userId;
  final Map<String, List<GameScore>> scores;

  User({
    required this.nickname,
    required this.userId,
    required this.scores,
  });

  Map<String, dynamic> toJson() {
    return {
      "nickname": nickname,
      "userId": userId,
      "scores": scores.map((key, value) => MapEntry(key, value.map((score) => score.toJson()).toList())),
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      nickname: json["nickname"] ?? "",
      userId: json["userId"] ?? "",
      scores: (json["scores"] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(
          key, 
          (value as List).map((score) => GameScore.fromJson(score)).toList()
        ),
      ) ?? {},
    );
  }
}

class GameScore {
  final String difficulty;
  final int score;
  final int totalQuestions;
  final DateTime date;

  GameScore({
    required this.difficulty,
    required this.score,
    required this.totalQuestions,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      "difficulty": difficulty,
      "score": score,
      "totalQuestions": totalQuestions,
      "date": date.toIso8601String(),
    };
  }

  factory GameScore.fromJson(Map<String, dynamic> json) {
    return GameScore(
      difficulty: json["difficulty"],
      score: json["score"],
      totalQuestions: json["totalQuestions"],
      date: DateTime.parse(json["date"]),
    );
  }
}
