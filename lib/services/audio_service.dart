import "package:audioplayers/audioplayers.dart";

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  AudioPlayer? _backgroundMusicPlayer;
  AudioPlayer? _soundEffectPlayer;
  bool _isBackgroundMusicPlaying = false;

  // 初始化音频播放器
  Future<void> initialize() async {
    _backgroundMusicPlayer = AudioPlayer();
    _soundEffectPlayer = AudioPlayer();
  }

  // 播放背景音乐
  Future<void> playBackgroundMusic() async {
    if (_backgroundMusicPlayer == null) {
      await initialize();
    }
    
    if (!_isBackgroundMusicPlaying) {
      try {
        // 使用本地背景音乐文件
        await _backgroundMusicPlayer!.play(AssetSource("bg_music.mp3"));
        _isBackgroundMusicPlaying = true;
        
        // 设置循环播放
        _backgroundMusicPlayer!.onPlayerComplete.listen((event) {
          if (_isBackgroundMusicPlaying) {
            playBackgroundMusic();
          }
        });
      } catch (e) {
        print("Error playing background music: $e");
      }
    }
  }

  // 停止背景音乐
  Future<void> stopBackgroundMusic() async {
    if (_backgroundMusicPlayer != null) {
      await _backgroundMusicPlayer!.stop();
      _isBackgroundMusicPlaying = false;
    }
  }

  // 播放答对音效（Wow）
  Future<void> playCorrectSound() async {
    if (_soundEffectPlayer == null) {
      await initialize();
    }
    
    try {
      await _soundEffectPlayer!.play(AssetSource("wow.mp3"));
    } catch (e) {
      print("Error playing correct sound: $e");
    }
  }

  // 播放答错音效（Oho）
  Future<void> playWrongSound() async {
    if (_soundEffectPlayer == null) {
      await initialize();
    }
    
    try {
      await _soundEffectPlayer!.play(AssetSource("oho.mp3"));
    } catch (e) {
      print("Error playing wrong sound: $e");
    }
  }

  // 释放资源
  Future<void> dispose() async {
    await _backgroundMusicPlayer?.dispose();
    await _soundEffectPlayer?.dispose();
    _backgroundMusicPlayer = null;
    _soundEffectPlayer = null;
    _isBackgroundMusicPlaying = false;
  }
}
