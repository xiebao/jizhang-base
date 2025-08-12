import "package:flutter/material.dart";
import "services/fish_auth_service.dart";

class FishLoginScreen extends StatefulWidget {
  const FishLoginScreen({super.key});

  @override
  State<FishLoginScreen> createState() => _FishLoginScreenState();
}

class _FishLoginScreenState extends State<FishLoginScreen>
    with TickerProviderStateMixin {
  final TextEditingController _nicknameController = TextEditingController();
  bool _isLoading = false;
  bool _agreedToTerms = false;

  late AnimationController _bubbleController;
  late AnimationController _fishController;
  late Animation<double> _bubbleAnimation;
  late Animation<double> _fishAnimation;

  @override
  void initState() {
    super.initState();
    
    // 气泡动画
    _bubbleController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    _bubbleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _bubbleController, curve: Curves.easeInOut),
    );

    // 鱼动画
    _fishController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _fishAnimation = Tween<double>(begin: -10.0, end: 10.0).animate(
      CurvedAnimation(parent: _fishController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _bubbleController.dispose();
    _fishController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_nicknameController.text.isEmpty) {
      _showError("请输入您的昵称");
      return;
    }

    if (!_agreedToTerms) {
      _showError("请同意用户协议和隐私政策");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final success = await AuthService.login(_nicknameController.text);
      
      if (success) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, "/home");
        }
      } else {
        if (mounted) {
          _showError("登录失败，请重试");
        }
      }
    } catch (e) {
      if (mounted) {
        _showError("登录失败，请重试");
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
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
                  Color(0xFF1E3A8A),
                  Color(0xFF3B82F6),
                  Color(0xFF06B6D4),
                ],
              ),
            ),
          ),
          
          // 装饰性气泡和海洋生物
          Positioned(
            top: 100,
            right: 30,
            child: AnimatedBuilder(
              animation: _bubbleAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _bubbleAnimation.value * 20),
                  child: const Text(
                    '🫧',
                    style: TextStyle(fontSize: 40),
                  ),
                );
              },
            ),
          ),
          
          Positioned(
            top: 200,
            left: 20,
            child: AnimatedBuilder(
              animation: _fishAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(_fishAnimation.value, 0),
                  child: const Text(
                    '🐠',
                    style: TextStyle(fontSize: 35),
                  ),
                );
              },
            ),
          ),
          
          Positioned(
            bottom: 150,
            right: 40,
            child: const Text(
              '🐙',
              style: TextStyle(fontSize: 30),
            ),
          ),
          
          Positioned(
            bottom: 200,
            left: 50,
            child: const Text(
              '🦀',
              style: TextStyle(fontSize: 25),
            ),
          ),

          // 主要内容
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // 顶部导航栏
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const Text(
                        'FirstMathFish',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 48), // 平衡布局
                    ],
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // 欢迎区域
                  Column(
                    children: [
                      const Text(
                        '🐠',
                        style: TextStyle(fontSize: 80),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        '欢迎来到海洋数学世界',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '和海洋朋友们一起学习数学吧！',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 40),

                  // 登录表单
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(20),
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
                          "昵称",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3B82F6),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextField(
                            controller: _nicknameController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              hintText: "请输入您的昵称",
                              prefixIcon: Icon(Icons.person, color: Color(0xFF3B82F6)),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // 登录按钮
                        Container(
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF3B82F6), Color(0xFF06B6D4)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF3B82F6).withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : const Text(
                                    "开始冒险",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // 隐私政策和用户协议
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Checkbox(
                          value: _agreedToTerms,
                          onChanged: (value) {
                            setState(() {
                              _agreedToTerms = value ?? false;
                            });
                          },
                          activeColor: const Color(0xFF3B82F6),
                        ),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                              children: [
                                const TextSpan(text: "我同意 "),
                                WidgetSpan(
                                  child: GestureDetector(
                                    onTap: () => _showUserAgreement(),
                                    child: const Text(
                                      "用户协议",
                                      style: TextStyle(
                                        color: Color(0xFF3B82F6),
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ),
                                const TextSpan(text: " 和 "),
                                WidgetSpan(
                                  child: GestureDetector(
                                    onTap: () => _showPrivacyPolicy(),
                                    child: const Text(
                                      "隐私政策",
                                      style: TextStyle(
                                        color: Color(0xFF3B82F6),
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
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
            ),
          ),
        ],
      ),
    );
  }

  void _showUserAgreement() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("用户协议"),
        content: const SingleChildScrollView(
          child: Text(
            "FirstMathFish 服务条款摘要：\n\n"
            "• 仅用于教育目的\n"
            "• 适合所有年龄段的用户，需要适当监督\n"
            "• 用户负责适当使用\n"
            "• 禁止商业使用或逆向工程\n"
            "• 我们按原样提供应用程序以支持教育\n"
            "• 应用程序应补充而非替代正规教育\n"
            "• 我们可能会根据需要更新功能和条款\n\n"
            "完整条款请访问我们的网站。\n"
            "联系方式: support@good2good.tech",
            style: TextStyle(fontSize: 14),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("关闭"),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("隐私政策"),
        content: const SingleChildScrollView(
          child: Text(
            "FirstMathFish 隐私政策摘要：\n\n"
            "• 我们只收集您的昵称和游戏进度\n"
            "• 所有数据都存储在您的设备本地\n"
            "• 不会与第三方共享个人信息\n"
            "• 没有广告或跟踪\n"
            "• 对所有用户都符合隐私要求\n"
            "• 您可以随时删除您的数据\n"
            "• 用户对其数据有完全控制权\n\n"
            "完整隐私政策请访问我们的网站。\n"
            "联系方式: privacy@good2good.tech",
            style: TextStyle(fontSize: 14),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("关闭"),
          ),
        ],
      ),
    );
  }
}
