import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home/fish_webview.dart';
import 'fish_version_check_service.dart';
import 'screens/auth/login_screen.dart';
import 'screens/main/main_screen.dart';
import 'services/auth_service.dart';
import 'services/theme_service.dart';
import 'utils/init_test_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await TestDataInitializer.initializeTestData();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeService(),
      child: Consumer<ThemeService>(
        builder: (context, themeService, child) {
          return MaterialApp(
            title: 'XMoneyNote',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
              useMaterial3: true,
              brightness: Brightness.light,
            ),
            darkTheme: ThemeData(
              primarySwatch: Colors.blue,
              useMaterial3: true,
              brightness: Brightness.dark,
            ),
            themeMode: themeService.themeMode,
            initialRoute: '/',
            routes: {
              '/': (context) => const WelcomeScreen(),
              '/login': (context) => const LoginScreen(),
              '/home': (context) => const MainScreen(),
            },
          );
        },
      ),
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
                  Icons.account_balance_wallet,
                  size: 100,
                  color: Colors.white,
                ),
                const SizedBox(height: 24),
                const Text(
                  'XMoneyNote',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Track your finances easily!',
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
                    'Get Started',
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


