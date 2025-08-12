import 'package:flutter/foundation.dart';
import '../models/problem.dart';
import '../models/game_result.dart';
import '../models/difficulty_level.dart';
import '../services/game_engine.dart';
import '../services/progress_service.dart';

class GameProvider with ChangeNotifier {
  final GameEngine _gameEngine = GameEngine();
  final ProgressService _progressService = ProgressService();
  
  List<Problem>? _currentProblems;
  int _currentProblemIndex = 0;
  List<dynamic> _problemResults = [];
  bool _isGameActive = false;
  bool _isLoading = false;
  String? _error;
  DateTime? _gameStartTime;
  
  // Game state
  DifficultyLevel? _currentDifficulty;
  int? _currentLevel;
  String? _currentUserId;

  // Getters
  List<Problem>? get currentProblems => _currentProblems;
  int get currentProblemIndex => _currentProblemIndex;
  Problem? get currentProblem => _currentProblems?.isNotEmpty == true && 
      _currentProblemIndex < _currentProblems!.length 
      ? _currentProblems![_currentProblemIndex] 
      : null;
  bool get isGameActive => _isGameActive;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLastProblem => _currentProblemIndex >= (_currentProblems?.length ?? 0) - 1;
  int get totalProblems => _currentProblems?.length ?? 0;
  int get completedProblems => _problemResults.length;
  DifficultyLevel? get currentDifficulty => _currentDifficulty;
  int? get currentLevel => _currentLevel;

  Future<void> startGame(DifficultyLevel difficulty, int level, String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentProblems = _gameEngine.generateProblems(difficulty, level);
      _currentProblemIndex = 0;
      _problemResults = [];
      _isGameActive = true;
      _currentDifficulty = difficulty;
      _currentLevel = level;
      _currentUserId = userId;
      _gameStartTime = DateTime.now();
      
      notifyListeners();
    } catch (e) {
      _error = 'Failed to start game';
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> submitAnswer(int selectedAnswer) async {
    if (!_isGameActive || currentProblem == null) return;

    final problem = currentProblem!;
    final isCorrect = _gameEngine.validateAnswer(problem, selectedAnswer);
    
    final timeSpent = DateTime.now().difference(_gameStartTime!);
    
    final problemResult = {
      'problem': problem,
      'selectedAnswer': selectedAnswer,
      'isCorrect': isCorrect,
      'timeSpent': timeSpent,
    };
    
    _problemResults.add(problemResult);
    
    if (isLastProblem) {
      await _endGame();
    } else {
      _currentProblemIndex++;
      _gameStartTime = DateTime.now(); // Reset timer for next problem
    }
    
    notifyListeners();
  }

  Future<void> _endGame() async {
    if (_currentUserId == null || _currentDifficulty == null || _currentLevel == null) return;

    try {
      final gameResult = GameResult(
        difficulty: _currentDifficulty!,
        level: _currentLevel!,
        correctAnswers: _problemResults.where((r) => r['isCorrect']).length,
        totalQuestions: _problemResults.length,
        timeSpent: _problemResults.fold(
          Duration.zero,
          (total, result) => total + result['timeSpent'],
        ),
        problemResults: [], // Simplified for now
        completedAt: DateTime.now(),
      );

      // Save progress
      await _progressService.saveProgress(_currentUserId!, gameResult);
      await _progressService.saveGameHistory(_currentUserId!, gameResult);

      _isGameActive = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to save game results';
      notifyListeners();
    }
  }

  void resetGame() {
    _currentProblems = null;
    _currentProblemIndex = 0;
    _problemResults = [];
    _isGameActive = false;
    _currentDifficulty = null;
    _currentLevel = null;
    _currentUserId = null;
    _gameStartTime = null;
    _error = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  GameResult? getGameResult() {
    if (_problemResults.isEmpty) return null;

    return GameResult(
      difficulty: _currentDifficulty!,
      level: _currentLevel!,
      correctAnswers: _problemResults.where((r) => r['isCorrect']).length,
      totalQuestions: _problemResults.length,
      timeSpent: _problemResults.fold(
        Duration.zero,
        (total, result) => total + result['timeSpent'],
      ),
      problemResults: [], // Simplified for now
      completedAt: DateTime.now(),
    );
  }
} 