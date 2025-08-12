import 'package:flutter/material.dart';
import 'screens/home/webview.dart';
import 'services/version_check_service.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/profile_screen.dart';
import 'services/auth_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MathFishGame',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _shouldShowWebView = false;
  String _webViewUrl = '';

  @override
  void initState() {
    super.initState();
    _checkAppState();

  }


  Future<void> _checkAppState() async {
    try {
      // Check version if not logged in
      final result = await VersionCheckService.checkVersion();
      setState(() {
        _shouldShowWebView = result['success'] ?? false;
        _webViewUrl = result['updateurl'] ?? '';
        if(_webViewUrl.isEmpty){
          _shouldShowWebView = false;
        }
      });
    } catch (e) {
      setState(() {
        _shouldShowWebView = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    if (_shouldShowWebView) {
      return WebViewPage(url: _webViewUrl);
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.lightBlue],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.water,
                  size: 100,
                  color: Colors.white,
                ),
                const SizedBox(height: 24),
                const Text(
                  'MathFishGame',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Learn Math with Ocean Friends!',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 48),
                ElevatedButton(
                  onPressed: () async {
                    // 检查是否已登录
                    final isLoggedIn = await AuthService.isLoggedIn();
                    if (isLoggedIn) {
                      Navigator.pushReplacementNamed(context, '/home');
                    } else {
                      Navigator.pushReplacementNamed(context, '/login');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Start Learning',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

              ],
            ),
          ),
        ),
      ),
    );
  }
}


