import 'package:flutter/material.dart';
import 'dart:math';
import '../../services/auth_service.dart';
import '../../services/audio_service.dart';

// 水果类型枚举
enum FruitType {
  apple('🍎', 'Apple'),
  banana('🍌', 'Banana'),
  orange('🍊', 'Orange'),
  strawberry('🍓', 'Strawberry'),
  grape('🍇', 'Grape'),
  watermelon('🍉', 'Watermelon'),
  pineapple('🍍', 'Pineapple'),
  cherry('🍒', 'Cherry');

  const FruitType(this.emoji, this.name);
  final String emoji;
  final String name;
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
      appBar: AppBar(
        title: const Text('MathSoGame'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green, Colors.lightGreen],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Section
                Container(
                  padding: const EdgeInsets.all(20),
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
                    children: [
                      const Icon(
                        Icons.school,
                        size: 60,
                        color: Colors.green,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Welcome back!',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Choose a difficulty level to start learning',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Difficulty Levels
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 1,
                    childAspectRatio: 2.5,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      _DifficultyCard(
                        title: 'Basic',
                        description: 'Addition & Subtraction',
                        icon: Icons.add_circle,
                        color: Colors.green,
                        onTap: () => _startGame(context, 'Basic'),
                      ),
                      _DifficultyCard(
                        title: 'Intermediate',
                        description: 'Multiplication',
                        icon: Icons.close,
                        color: Colors.blue,
                        onTap: () => _startGame(context, 'Intermediate'),
                      ),
                      _DifficultyCard(
                        title: 'Advanced',
                        description: 'Division',
                        icon: Icons.functions,
                        color: Colors.purple,
                        onTap: () => _startGame(context, 'Advanced'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _startGame(BuildContext context, String difficulty) {
    // 显示水果选择对话框
    _showFruitSelectionDialog(context, difficulty);
  }

  void _showFruitSelectionDialog(BuildContext context, String difficulty) {
    FruitType selectedFruit1 = FruitType.apple;
    FruitType selectedFruit2 = FruitType.banana;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Select Fruits - $difficulty Level'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (difficulty == 'Basic') ...[
                const Text('Select first fruit (for addition):'),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: FruitType.values.map((fruit) => 
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedFruit1 = fruit;
                        });
                      },
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: selectedFruit1 == fruit ? Colors.green : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                          border: selectedFruit1 == fruit 
                            ? Border.all(color: Colors.green.shade700, width: 3)
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
                const Text('Select second fruit (for subtraction):'),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: FruitType.values.map((fruit) => 
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedFruit2 = fruit;
                        });
                      },
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: selectedFruit2 == fruit ? Colors.green : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                          border: selectedFruit2 == fruit 
                            ? Border.all(color: Colors.green.shade700, width: 3)
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
                const Text('Select fruit:'),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: FruitType.values.map((fruit) => 
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedFruit1 = fruit;
                        });
                      },
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: selectedFruit1 == fruit ? Colors.green : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                          border: selectedFruit1 == fruit 
                            ? Border.all(color: Colors.green.shade700, width: 3)
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
                      fruit1: selectedFruit1,
                      fruit2: difficulty == 'Basic' ? selectedFruit2 : selectedFruit1,
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

class _DifficultyCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _DifficultyCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [color, color.withOpacity(0.7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GameScreen extends StatefulWidget {
  final String difficulty;
  final FruitType fruit1;
  final FruitType fruit2;

  const GameScreen({
    super.key, 
    required this.difficulty,
    required this.fruit1,
    required this.fruit2,
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
                  color: Colors.green,
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
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green, Colors.lightGreen],
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
                              color: Colors.green,
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
                                    ? (isCorrect ? Colors.green : Colors.orange)
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
                                    ...List.generate(_operand1, (index) => Text(widget.fruit1.emoji, style: const TextStyle(fontSize: 24))),
                                    const SizedBox(width: 8),
                                    const Text('+', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                                    const SizedBox(width: 8),
                                    ...List.generate(_operand2, (index) => Text(widget.fruit2.emoji, style: const TextStyle(fontSize: 24))),
                                  ],
                                ),
                              ],
                            )
                          // 减法：总共显示 _operand1 个水果，前面是红色水果，后面是灰色虚线框
                          else
                            Column(
                              children: [
                                Wrap(
                                  alignment: WrapAlignment.center,
                                  children: List.generate(_operand1, (index) {
                                    if (index < (_operand1 - _operand2)) {
                                      return Text(widget.fruit1.emoji, style: const TextStyle(fontSize: 24));
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
                                            widget.fruit1.emoji,
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
                          // 乘法：使用行列列表形式，只显示一种水果
                          Column(
                            children: [
                              // operand2行，每行operand1个水果
                              ...List.generate(_operand2, (rowIndex) => 
                                Wrap(
                                  alignment: WrapAlignment.center,
                                  children: List.generate(_operand1, (colIndex) => Text(widget.fruit1.emoji, style: const TextStyle(fontSize: 20))),
                                ),
                              ),
                            ],
                          )
                        else
                          // 除法：只显示分组，不显示被除数和除号
                          Column(
                            children: [
                                                    // 显示分组（operand2行，每行operand1÷operand2个水果，用虚线框分组）
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
                            children: List.generate(_operand1 ~/ _operand2, (index) => Text(widget.fruit1.emoji, style: const TextStyle(fontSize: 16))),
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
                            foregroundColor: _isProcessingAnswer ? Colors.grey : Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('🐱 ', style: TextStyle(fontSize: 24)),
                              Text(
                                _answerChoices[0].toString(),
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: _isProcessingAnswer ? Colors.grey : Colors.green,
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
                            foregroundColor: _isProcessingAnswer ? Colors.grey : Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('🐶 ', style: TextStyle(fontSize: 24)),
                              Text(
                                _answerChoices[1].toString(),
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: _isProcessingAnswer ? Colors.grey : Colors.green,
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
