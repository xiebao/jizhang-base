import "dart:convert";
import "dart:math";
import "package:shared_preferences/shared_preferences.dart";
import "../models/fish_user.dart";

class AuthService {
  static const String _userKey = "current_user";
  static const String _isLoggedInKey = "is_logged_in";

  // 检查是否已登录
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  // 生成6位随机ID
  static String _generateUserId() {
    final random = Random();
    return (100000 + random.nextInt(900000)).toString();
  }

  // 登录
  static Future<bool> login(String nickname) async {
    if (nickname.isEmpty) {
      return false;
    }

    final prefs = await SharedPreferences.getInstance();
    
    // 生成用户ID
    final userId = _generateUserId();
    
    // 创建新用户或获取现有用户
    FishUser user = FishUser(
      nickname: nickname,
      userId: userId,
      scores: await _loadUserScores(nickname),
    );

    // 保存用户信息
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
    await prefs.setBool(_isLoggedInKey, true);

    return true;
  }

  // 退出登录
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.setBool(_isLoggedInKey, false);
  }

  // 获取当前用户
  static Future<FishUser?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    
    if (userJson != null) {
      return FishUser.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  // 保存游戏成绩
  static Future<void> saveGameScore(String difficulty, int score, int totalQuestions) async {
    final user = await getCurrentUser();
    if (user == null) return;

    final gameScore = FishGameScore(
      difficulty: difficulty,
      score: score,
      totalQuestions: totalQuestions,
      date: DateTime.now(),
    );

    // 更新用户成绩
    final updatedScores = Map<String, List<FishGameScore>>.from(user.scores);
    if (!updatedScores.containsKey(difficulty)) {
      updatedScores[difficulty] = [];
    }
    updatedScores[difficulty]!.add(gameScore);

    final updatedUser = FishUser(
      nickname: user.nickname,
      userId: user.userId,
      scores: updatedScores,
    );

    // 保存更新后的用户信息
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(updatedUser.toJson()));
  }

  // 加载用户成绩
  static Future<Map<String, List<FishGameScore>>> _loadUserScores(String nickname) async {
    final prefs = await SharedPreferences.getInstance();
    final scoresKey = "scores_$nickname";
    final scoresJson = prefs.getString(scoresKey);
    
    if (scoresJson != null) {
      final scoresMap = jsonDecode(scoresJson) as Map<String, dynamic>;
      return scoresMap.map(
        (key, value) => MapEntry(
          key, 
          (value as List).map((score) => FishGameScore.fromJson(score)).toList()
        ),
      );
    }
    
    return {};
  }
}
