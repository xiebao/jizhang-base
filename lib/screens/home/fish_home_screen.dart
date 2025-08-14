import 'package:flutter/material.dart';
import 'dart:math';
import '../../services/fish_auth_service.dart';
import '../../services/fish_audio_service.dart';

// 鱼类类型枚举
enum FishType {
  clownfish('🐠', 'Clownfish'),
  dolphin('🐬', 'Dolphin'),
  shark('🦈', 'Shark'),
  whale('🐋', 'Whale'),
  octopus('🐙', 'Octopus'),
  seahorse('🦄', 'Seahorse'),
  starfish('⭐', 'Starfish'),
  jellyfish('💎', 'Jellyfish');

  const FishType(this.emoji, this.name);
  final String emoji;
  final String name;
}

class FishHomeScreen extends StatefulWidget {
  const FishHomeScreen({super.key});

  @override
  State<FishHomeScreen> createState() => _FishHomeScreenState();
}

class _FishHomeScreenState extends State<FishHomeScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final isLoggedIn = await AuthService.isLoggedIn();
    if (!isLoggedIn && mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
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
        child: SafeArea(
          child: Stack(
            children: [
              // 背景装饰元素
              Positioned(
                top: 50,
                left: 20,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                top: 100,
                right: 30,
                child: Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                bottom: 200,
                left: 40,
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              
              // 主要内容 - 使用ListView
              ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                children: [
                  // 顶部导航栏
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'MathFishGame',
                          style: TextStyle(
                            fontSize: 28,
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
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.person, color: Colors.white, size: 28),
                            onPressed: () {
                              Navigator.pushNamed(context, '/profile');
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // 欢迎区域
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 20),
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
                        const Text(
                          '🐠',
                          style: TextStyle(fontSize: 80),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Welcome to the Ocean!',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E3A8A),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Choose your math adventure and dive into learning!',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  
                  // 难度选择标题
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    child: const Text(
                      'Choose Your Adventure',
                      style: TextStyle(
                        fontSize: 22,
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
                      textAlign: TextAlign.center,
                    ),
                  ),
                  
                  // 难度选择卡片
                  _DifficultyCard(
                    title: 'Basic',
                    subtitle: 'Addition & Subtraction',
                    icon: '➕',
                    color: const Color(0xFF10B981),
                    onTap: () => _startGame(context, 'Basic'),
                  ),
                  const SizedBox(height: 16),
                  _DifficultyCard(
                    title: 'Intermediate',
                    subtitle: 'Multiplication',
                    icon: '✖️',
                    color: const Color(0xFFF59E0B),
                    onTap: () => _startGame(context, 'Intermediate'),
                  ),
                  const SizedBox(height: 16),
                  _DifficultyCard(
                    title: 'Advanced',
                    subtitle: 'Division',
                    icon: '➗',
                    color: const Color(0xFFEF4444),
                    onTap: () => _startGame(context, 'Advanced'),
                  ),
                  
                  // 底部间距
                  const SizedBox(height: 40),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _startGame(BuildContext context, String difficulty) {
    // 显示鱼类选择对话框
    _showFishSelectionDialog(context, difficulty);
  }

  void _showFishSelectionDialog(BuildContext context, String difficulty) {
    FishType selectedFish1 = FishType.clownfish;
    FishType selectedFish2 = FishType.dolphin;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Select Fish - $difficulty Level'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (difficulty == 'Basic') ...[
                const Text('Select first fish (for addition):'),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: FishType.values.map((fruit) => 
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedFish1 = fruit;
                        });
                      },
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: selectedFish1 == fruit ? Colors.blue : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                          border: selectedFish1 == fruit 
                            ? Border.all(color: Colors.blue.shade700, width: 3)
                            : null,
                        ),
                        child: Center(
                          child: Text(
                            fruit.emoji,
                            style: const TextStyle(fontSize: 32),
                          ),
                        ),
                      ),
                    ),
                  ).toList(),
                ),
                const SizedBox(height: 24),
                const Text('Select second fish (for subtraction):'),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: FishType.values.map((fruit) => 
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedFish2 = fruit;
                        });
                      },
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: selectedFish2 == fruit ? Colors.blue : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                          border: selectedFish2 == fruit 
                            ? Border.all(color: Colors.blue.shade700, width: 3)
                            : null,
                        ),
                        child: Center(
                          child: Text(
                            fruit.emoji,
                            style: const TextStyle(fontSize: 32),
                          ),
                        ),
                      ),
                    ),
                  ).toList(),
                ),
              ] else ...[
                const Text('Select fish:'),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: FishType.values.map((fruit) => 
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedFish1 = fruit;
                        });
                      },
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: selectedFish1 == fruit ? Colors.blue : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                          border: selectedFish1 == fruit 
                            ? Border.all(color: Colors.blue.shade700, width: 3)
                            : null,
                        ),
                        child: Center(
                          child: Text(
                            fruit.emoji,
                            style: const TextStyle(fontSize: 32),
                          ),
                        ),
                      ),
                    ),
                  ).toList(),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GameScreen(
                      difficulty: difficulty,
                      fish1: selectedFish1,
                      fish2: difficulty == 'Basic' ? selectedFish2 : selectedFish1,
                    ),
                  ),
                );
              },
              child: const Text('Start Game'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DifficultyCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String icon;
  final Color color;
  final VoidCallback onTap;

  const _DifficultyCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  State<_DifficultyCard> createState() => _DifficultyCardState();
}

class _DifficultyCardState extends State<_DifficultyCard> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        _controller.forward();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _controller.reverse();
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // 图标容器
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: widget.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: widget.color.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        widget.icon,
                        style: const TextStyle(fontSize: 32),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  // 文本内容
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: widget.color,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.subtitle,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 箭头图标
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: widget.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: widget.color,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class GameScreen extends StatefulWidget {
  final String difficulty;
  final FishType fish1;
  final FishType fish2;

  const GameScreen({
    super.key, 
    required this.difficulty,
    required this.fish1,
    required this.fish2,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int _currentQuestion = 1;
  int _totalQuestions = 10;
  int _score = 0;
  int _operand1 = 0;
  int _operand2 = 0;
  String _operation = '+';
  int _correctAnswer = 0;
  List<int> _answerChoices = [];
  List<bool> _questionResults = []; // 记录每题的答题结果
  bool _isProcessingAnswer = false; // 防止重复点击
  final AudioService _audioService = AudioService();

  @override
  void initState() {
    super.initState();
    _generateQuestion();
    // 播放背景音乐
    _audioService.playBackgroundMusic();
  }

  void _generateQuestion() {
    
    // 使用更好的随机数生成
    final random = Random();
    int attempts = 0;
    const maxAttempts = 10;
    
    do {
      attempts++;
      
      switch (widget.difficulty) {
        case 'Basic':
          _operand1 = random.nextInt(20) + 1;
          _operand2 = random.nextInt(20) + 1;
          _operation = random.nextBool() ? '+' : '-';
          // 对于减法，确保operand1 >= operand2，这样结果为正数
          if (_operation == '-' && _operand1 < _operand2) {
            // 交换operand1和operand2，确保operand1 >= operand2
            int temp = _operand1;
            _operand1 = _operand2;
            _operand2 = temp;
          }
          _correctAnswer = _operation == '+' ? _operand1 + _operand2 : _operand1 - _operand2;
          break;
        case 'Intermediate':
          _operand1 = random.nextInt(10) + 1;
          _operand2 = random.nextInt(10) + 1;
          _operation = '×';
          _correctAnswer = _operand1 * _operand2;
          break;
        case 'Advanced':
          _operand2 = random.nextInt(10) + 1;
          _operand1 = _operand2 * (random.nextInt(10) + 1);
          _operation = '÷';
          _correctAnswer = _operand1 ~/ _operand2;
          break;
      }

      // 确保答案为正数
      if (_correctAnswer <= 0) {
        continue;
      }
      
      // 生成答案选项
      _answerChoices = [_correctAnswer];
      int choiceAttempts = 0;
      while (_answerChoices.length < 2 && choiceAttempts < 20) {
        choiceAttempts++;
        int wrongAnswer = _correctAnswer + random.nextInt(10) - 5;
        if (wrongAnswer > 0 && wrongAnswer != _correctAnswer && !_answerChoices.contains(wrongAnswer)) {
          _answerChoices.add(wrongAnswer);
        }
      }
      
      // 如果无法生成足够的错误答案，添加一个简单的错误答案
      if (_answerChoices.length < 2) {
        int simpleWrong = _correctAnswer + 1;
        if (!_answerChoices.contains(simpleWrong)) {
          _answerChoices.add(simpleWrong);
        }
      }
      
      _answerChoices.shuffle();
      
      // 如果成功生成，跳出循环
      if (_correctAnswer > 0 && _answerChoices.length >= 2) {
        break;
      }
      
    } while (attempts < maxAttempts);
    
    // 如果达到最大尝试次数，使用默认题目
    if (attempts >= maxAttempts) {
      _operand1 = 5;
      _operand2 = 3;
      _operation = '+';
      _correctAnswer = 8;
      _answerChoices = [8, 7];
    }
  }

  void _checkAnswer(int selectedAnswer) {
    
    // 防止重复点击
    if (_isProcessingAnswer) {
      return;
    }
    
    _isProcessingAnswer = true;
    
    bool isCorrect = selectedAnswer == _correctAnswer;
    
    setState(() {
      _questionResults.add(isCorrect);
      if (isCorrect) {
        _score++;
      }
    });

    if (isCorrect) {
      // 播放答对音效
      _audioService.playCorrectSound();
      _showCelebrationDialog();
    } else {
      // 播放答错音效
      _audioService.playWrongSound();
      _showSadDialog();
    }

    // 延迟进入下一题，让用户看到反馈
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        if (_currentQuestion < _totalQuestions) {
          setState(() {
            _currentQuestion++;
            _generateQuestion();
            _isProcessingAnswer = false; // 重置状态
          });
        } else {
          _showGameResult();
          _isProcessingAnswer = false; // 重置状态
        }
      }
    });
  }

  void _showGameResult() async {
    // 保存游戏成绩
    await AuthService.saveGameScore(widget.difficulty, _score, _totalQuestions);
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Game Complete!'),
        content: Text('Your score: $_score/$_totalQuestions'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Back to Home'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _currentQuestion = 1;
                _score = 0;
                _questionResults.clear();
                _generateQuestion();
                _isProcessingAnswer = false;
              });
            },
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }

  // 显示庆祝浮框
  void _showCelebrationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '🎉',
                style: TextStyle(fontSize: 60),
              ),
              const SizedBox(height: 16),
              const Text(
                'Great job!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'You got it right!',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // 1.5秒后自动关闭
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  // 显示沮丧浮框
  void _showSadDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '😔',
                style: TextStyle(fontSize: 60),
              ),
              const SizedBox(height: 16),
              const Text(
                'Try again!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'The answer is $_correctAnswer',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // 1.5秒后自动关闭
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    _audioService.stopBackgroundMusic();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.difficulty} Level'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.lightBlue],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Question $_currentQuestion of $_totalQuestions',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Score: $_score',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 8,
                        child: Row(
                          children: List.generate(_totalQuestions, (index) {
                            bool isAnswered = index < _questionResults.length;
                            bool isCorrect = isAnswered ? _questionResults[index] : false;
                            
                            return Expanded(
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 1),
                                decoration: BoxDecoration(
                                  color: isAnswered 
                                    ? (isCorrect ? Colors.blue : Colors.orange)
                                    : Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: Container(
                    padding: widget.difficulty == 'Intermediate' 
                      ? const EdgeInsets.all(16)  // 中级题目减少内边距，增加可用空间
                      : const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Visual representation based on difficulty
                        if (widget.difficulty == 'Basic')
                          // 加法：显示总数量的图标
                          if (_operation == '+')
                            Column(
                              children: [
                                Wrap(
                                  alignment: WrapAlignment.center,
                                  children: [
                                    ...List.generate(_operand1, (index) => Text(widget.fish1.emoji, style: const TextStyle(fontSize: 24))),
                                    const SizedBox(width: 8),
                                    const Text('+', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                                    const SizedBox(width: 8),
                                    ...List.generate(_operand2, (index) => Text(widget.fish2.emoji, style: const TextStyle(fontSize: 24))),
                                  ],
                                ),
                              ],
                            )
                          // 减法：总共显示 _operand1 个鱼类，前面是蓝色鱼类，后面是灰色虚线框
                          else
                            Column(
                              children: [
                                Wrap(
                                  alignment: WrapAlignment.center,
                                  children: List.generate(_operand1, (index) {
                                    if (index < (_operand1 - _operand2)) {
                                      return Text(widget.fish1.emoji, style: const TextStyle(fontSize: 24));
                                    } else {
                                      return Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey.shade400,
                                            width: 2,
                                            style: BorderStyle.solid,
                                          ),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Center(
                                          child: Text(
                                            widget.fish1.emoji,
                                            style: const TextStyle(fontSize: 20, color: Colors.grey),
                                          ),
                                        ),
                                      );
                                    }
                                  }),
                                ),
                              ],
                            )
                        else if (widget.difficulty == 'Intermediate')
                          // 乘法：使用行列列表形式，只显示一种鱼类
                          Column(
                            children: [
                              // operand2行，每行operand1个鱼类
                              ...List.generate(_operand2, (rowIndex) => 
                                Wrap(
                                  alignment: WrapAlignment.center,
                                  children: List.generate(_operand1, (colIndex) => Text(widget.fish1.emoji, style: const TextStyle(fontSize: 20))),
                                ),
                              ),
                            ],
                          )
                        else
                          // 除法：只显示分组，不显示被除数和除号
                          Column(
                            children: [
                                                    // 显示分组（operand2行，每行operand1÷operand2个鱼类，用虚线框分组）
                      ...List.generate(_operand2, (rowIndex) => 
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 2),
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey.shade400,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 2,
                            runSpacing: 2,
                            children: List.generate(_operand1 ~/ _operand2, (index) => Text(widget.fish1.emoji, style: const TextStyle(fontSize: 16))),
                          ),
                        ),
                      ),
                            ],
                          ),
                        const SizedBox(height: 24),
                        Text(
                          '$_operand1 $_operation $_operand2 = ?',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 80,
                        child: ElevatedButton(
                          onPressed: _isProcessingAnswer ? null : () {
                            _checkAnswer(_answerChoices[0]);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isProcessingAnswer ? Colors.grey.shade300 : Colors.white,
                            foregroundColor: _isProcessingAnswer ? Colors.grey : Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('🐠 ', style: TextStyle(fontSize: 24)),
                              Text(
                                _answerChoices[0].toString(),
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: _isProcessingAnswer ? Colors.grey : Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: SizedBox(
                        height: 80,
                        child: ElevatedButton(
                          onPressed: _isProcessingAnswer ? null : () {
                            _checkAnswer(_answerChoices[1]);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isProcessingAnswer ? Colors.grey.shade300 : Colors.white,
                            foregroundColor: _isProcessingAnswer ? Colors.grey : Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('🐬 ', style: TextStyle(fontSize: 24)),
                              Text(
                                _answerChoices[1].toString(),
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: _isProcessingAnswer ? Colors.grey : Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
