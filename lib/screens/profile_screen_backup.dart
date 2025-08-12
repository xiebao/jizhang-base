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
  late Animation<double> _avatarAnimation;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    
    _avatarController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _avatarAnimation = Tween<double>(begin: -3, end: 3).animate(
      CurvedAnimation(parent: _avatarController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _avatarController.dispose();
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

  Widget _buildScoreCard(String difficulty, List<GameScore> scores) {
    if (scores.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                difficulty,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "No scores yet",
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    // 计算平均分
    final totalScore = scores.fold(0, (sum, score) => sum + score.score);
    final totalQuestions = scores.fold(0, (sum, score) => sum + score.totalQuestions);
    final averageScore = totalQuestions > 0 ? (totalScore / totalQuestions * 100).round() : 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              difficulty,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Average Score: $averageScore%",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Total Games: ${scores.length}",
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            // 显示最近的5次成绩
            ...scores.take(5).map((score) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${score.score}/${score.totalQuestions}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${(score.score / score.totalQuestions * 100).round()}%",
                    style: TextStyle(
                      color: (score.score / score.totalQuestions * 100) >= 80 
                        ? Colors.green 
                        : (score.score / score.totalQuestions * 100) >= 60 
                          ? Colors.orange 
                          : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "${score.date.day}/${score.date.month}/${score.date.year}",
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        child: _user == null
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
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Text(
                            'My Profile',
                            style: TextStyle(
                              fontSize: 24,
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
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF3B82F6).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(
                                      color: const Color(0xFF3B82F6),
                                      width: 3,
                                    ),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      '🐠',
                                      style: TextStyle(fontSize: 50),
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
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E3A8A),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Math Adventure Champion',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
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
                            const Text(
                              'Your Achievements',
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
            ),
          ),
        ),
      ),
    );
  }
}
