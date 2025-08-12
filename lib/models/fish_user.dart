import "dart:math";

class FishUser {
  final String nickname;
  final String userId;
  final Map<String, List<FishGameScore>> scores;

  FishUser({
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

  factory FishUser.fromJson(Map<String, dynamic> json) {
    return FishUser(
      nickname: json["nickname"] ?? "",
      userId: json["userId"] ?? "",
      scores: (json["scores"] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(
          key, 
          (value as List).map((score) => FishGameScore.fromJson(score)).toList()
        ),
      ) ?? {},
    );
  }
}

class FishGameScore {
  final String difficulty;
  final int score;
  final int totalQuestions;
  final DateTime date;

  FishGameScore({
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

  factory FishGameScore.fromJson(Map<String, dynamic> json) {
    return FishGameScore(
      difficulty: json["difficulty"],
      score: json["score"],
      totalQuestions: json["totalQuestions"],
      date: DateTime.parse(json["date"]),
    );
  }
}
