import "package:flutter/material.dart";
import "../models/user.dart";
import "../services/auth_service.dart";

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with TickerProviderStateMixin {
  User? _user;
  late AnimationController _avatarController;
  late AnimationController _bubbleController;
  late Animation<double> _avatarAnimation;
  late Animation<double> _bubbleAnimation;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    
    _avatarController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _bubbleController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
    
    _avatarAnimation = Tween<double>(begin: -3, end: 3).animate(
      CurvedAnimation(parent: _avatarController, curve: Curves.easeInOut),
    );
    
    _bubbleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _bubbleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _avatarController.dispose();
    _bubbleController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final user = await AuthService.getCurrentUser();
    if (mounted) {
      setState(() {
        _user = user;
      });
    }
  }

  Future<void> _logout() async {
    await AuthService.logout();
    if (mounted) {
      Navigator.pushReplacementNamed(context, "/login");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 背景渐变
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF1E3A8A), // 深蓝色
                  Color(0xFF3B82F6), // 蓝色
                  Color(0xFF06B6D4), // 青色
                ],
              ),
            ),
          ),
          
          // 海洋装饰元素
          Positioned(
            top: 100,
            left: 20,
            child: AnimatedBuilder(
              animation: _bubbleAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, -10 * _bubbleAnimation.value),
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
            ),
          ),
          
          Positioned(
            top: 150,
            right: 30,
            child: AnimatedBuilder(
              animation: _bubbleAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, -15 * _bubbleAnimation.value),
                  child: Container(
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(7.5),
                    ),
                  ),
                );
              },
            ),
          ),
          
          Positioned(
            top: 200,
            left: 50,
            child: AnimatedBuilder(
              animation: _bubbleAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, -8 * _bubbleAnimation.value),
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                );
              },
            ),
          ),
          
          // 海洋生物装饰
          Positioned(
            top: 80,
            right: 20,
            child: Text(
              '🐙',
              style: TextStyle(fontSize: 30),
            ),
          ),
          
          Positioned(
            bottom: 200,
            left: 10,
            child: Text(
              '🦀',
              style: TextStyle(fontSize: 25),
            ),
          ),
          
          Positioned(
            bottom: 300,
            right: 10,
            child: Text(
              '🐚',
              style: TextStyle(fontSize: 20),
            ),
          ),
          
          // 主要内容
          _user == null
              ? const Center(child: CircularProgressIndicator(color: Colors.white))
              : SafeArea(
                  child: Column(
                    children: [
                      // 顶部导航栏
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Text(
                              '🐠 My Ocean Profile 🐠',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    offset: Offset(0, 2),
                                    blurRadius: 4,
                                    color: Colors.black26,
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.logout, color: Colors.white, size: 24),
                                onPressed: _logout,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // 用户信息卡片
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                          border: Border.all(
                            color: const Color(0xFF3B82F6).withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            // 动画头像
                            AnimatedBuilder(
                              animation: _avatarAnimation,
                              builder: (context, child) {
                                return Transform.translate(
                                  offset: Offset(_avatarAnimation.value, 0),
                                  child: Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF3B82F6),
                                          Color(0xFF06B6D4),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(60),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF3B82F6).withOpacity(0.3),
                                          blurRadius: 15,
                                          offset: const Offset(0, 8),
                                        ),
                                      ],
                                    ),
                                    child: const Center(
                                      child: Text(
                                        '🐠',
                                        style: TextStyle(fontSize: 60),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 20),
                            Text(
                              _user?.nickname ?? 'Ocean Explorer',
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E3A8A),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: const Color(0xFF10B981).withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: const Text(
                                '🏆 Math Adventure Champion',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF10B981),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.fingerprint,
                                  color: Color(0xFF6B7280),
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "ID: ${_user?.userId ?? 'Unknown'}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      // 成绩统计区域
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    '🏆 Your Achievements',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                          offset: Offset(0, 2),
                                          blurRadius: 4,
                                          color: Colors.black26,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: const Text(
                                      '🌟',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Expanded(
                                child: ListView(
                                  children: [
                                    _buildScoreCard('Basic', _user!.scores['Basic'] ?? []),
                                    const SizedBox(height: 16),
                                    _buildScoreCard('Intermediate', _user!.scores['Intermediate'] ?? []),
                                    const SizedBox(height: 16),
                                    _buildScoreCard('Advanced', _user!.scores['Advanced'] ?? []),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildScoreCard(String difficulty, List<GameScore> scores) {
    if (scores.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
          border: Border.all(
            color: _getDifficultyColor(difficulty).withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _getDifficultyColor(difficulty),
                    _getDifficultyColor(difficulty).withOpacity(0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: _getDifficultyColor(difficulty).withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  _getDifficultyIcon(difficulty),
                  style: const TextStyle(fontSize: 30),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              difficulty,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: _getDifficultyColor(difficulty),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "No scores yet",
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _getDifficultyColor(difficulty).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _getDifficultyColor(difficulty).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Text(
                "🎮 Start your first game!",
                style: TextStyle(
                  color: _getDifficultyColor(difficulty),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // 计算平均分
    final totalScore = scores.fold(0, (sum, score) => sum + score.score);
    final totalQuestions = scores.fold(0, (sum, score) => sum + score.totalQuestions);
    final averageScore = totalQuestions > 0 ? (totalScore / totalQuestions * 100).round() : 0;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _getDifficultyColor(difficulty).withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: _getDifficultyColor(difficulty).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _getDifficultyColor(difficulty),
                      _getDifficultyColor(difficulty).withOpacity(0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: _getDifficultyColor(difficulty).withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    _getDifficultyIcon(difficulty),
                    style: const TextStyle(fontSize: 30),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      difficulty,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: _getDifficultyColor(difficulty),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.games,
                          color: Color(0xFF6B7280),
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "Total Games: ${scores.length}",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // 平均分显示
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _getDifficultyColor(difficulty).withOpacity(0.1),
                  _getDifficultyColor(difficulty).withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _getDifficultyColor(difficulty).withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.star,
                  color: _getDifficultyColor(difficulty),
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  "Average Score: $averageScore%",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _getDifficultyColor(difficulty),
                  ),
                ),
                const SizedBox(width: 8),
                _getScoreEmoji(averageScore),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // 最近成绩
          if (scores.isNotEmpty) ...[
            Row(
              children: [
                const Text(
                  "📊 Recent Games",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getDifficultyColor(difficulty).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "Last 3",
                    style: TextStyle(
                      fontSize: 12,
                      color: _getDifficultyColor(difficulty),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...scores.take(3).map((score) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        "${score.score}/${score.totalQuestions}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _getScoreEmoji((score.score / score.totalQuestions * 100).round()),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getScoreColor(score.score, score.totalQuestions),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: _getScoreColor(score.score, score.totalQuestions).withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      "${((score.score / score.totalQuestions) * 100).round()}%",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ],
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'Basic':
        return const Color(0xFF10B981);
      case 'Intermediate':
        return const Color(0xFFF59E0B);
      case 'Advanced':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF3B82F6);
    }
  }

  String _getDifficultyIcon(String difficulty) {
    switch (difficulty) {
      case 'Basic':
        return '➕';
      case 'Intermediate':
        return '✖️';
      case 'Advanced':
        return '➗';
      default:
        return '🎯';
    }
  }

  Color _getScoreColor(int score, int total) {
    final percentage = score / total;
    if (percentage >= 0.8) {
      return const Color(0xFF10B981); // 绿色
    } else if (percentage >= 0.6) {
      return const Color(0xFFF59E0B); // 橙色
    } else {
      return const Color(0xFFEF4444); // 红色
    }
  }

  Widget _getScoreEmoji(int percentage) {
    if (percentage >= 90) {
      return const Text('🏆', style: TextStyle(fontSize: 16));
    } else if (percentage >= 80) {
      return const Text('🥇', style: TextStyle(fontSize: 16));
    } else if (percentage >= 70) {
      return const Text('🥈', style: TextStyle(fontSize: 16));
    } else if (percentage >= 60) {
      return const Text('🥉', style: TextStyle(fontSize: 16));
    } else {
      return const Text('💪', style: TextStyle(fontSize: 16));
    }
  }
}
