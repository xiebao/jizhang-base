import "package:flutter/material.dart";
import "../services/fish_auth_service.dart";

class FishLoginScreen extends StatefulWidget {
  const FishLoginScreen({super.key});

  @override
  State<FishLoginScreen> createState() => _FishLoginScreenState();
}

class _FishLoginScreenState extends State<FishLoginScreen> {
  final TextEditingController _nicknameController = TextEditingController();
  bool _isLoading = false;
  bool _agreedToTerms = false;

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_nicknameController.text.isEmpty) {
      _showError("Please enter your nickname");
      return;
    }

    if (!_agreedToTerms) {
      _showError("Please agree to the User Agreement and Privacy Policy");
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
          _showError("Login failed. Please try again.");
        }
      }
    } catch (e) {
      if (mounted) {
        _showError("Login failed. Please try again.");
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
      appBar: AppBar(
        title: const Text("Login"),
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
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo and Title
                const Icon(
                  Icons.school,
                  size: 80,
                  color: Colors.white,
                ),
                const SizedBox(height: 24),
                const Text(
                  "MathSoGame",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Enter your nickname to start learning",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),

                // Phone Number Input
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
                      const Text(
                        "Nickname",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _nicknameController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          hintText: "Enter your nickname",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text(
                                  "Login",
                                  style: TextStyle(fontSize: 18),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                // Privacy Policy and Terms Agreement
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
                        activeColor: Colors.green,
                      ),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                            children: [
                              const TextSpan(text: "I agree to the "),
                              WidgetSpan(
                                child: GestureDetector(
                                  onTap: () => _showUserAgreement(),
                                  child: const Text(
                                    "User Agreement",
                                    style: TextStyle(
                                      color: Colors.red,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ),
                              const TextSpan(text: " and "),
                              WidgetSpan(
                                child: GestureDetector(
                                  onTap: () => _showPrivacyPolicy(),
                                  child: const Text(
                                    "Privacy Policy",
                                    style: TextStyle(
                                      color: Colors.red,
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
      ),
    );
  }

  void _showUserAgreement() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("User Agreement"),
        content: const SingleChildScrollView(
          child: Text(
            "MathSoGame Terms of Service Summary:\n\n"
            "• Use the app for educational purposes only\n"
            "• Designed for users of all ages with appropriate supervision\n"
            "• Users are responsible for appropriate usage\n"
            "• No commercial use or reverse engineering\n"
            "• We provide the app 'as is' for educational support\n"
            "• App should supplement, not replace formal education\n"
            "• We may update features and terms as needed\n\n"
            "For complete terms, visit our website.\n"
            "Contact: support@good2good.tech",
            style: TextStyle(fontSize: 14),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Privacy Policy"),
        content: const SingleChildScrollView(
          child: Text(
            "MathSoGame Privacy Policy Summary:\n\n"
            "• We collect only your nickname and game progress\n"
            "• All data is stored locally on your device\n"
            "• No personal information is shared with third parties\n"
            "• No advertisements or tracking\n"
            "• Privacy compliant for all users\n"
            "• You can delete your data anytime\n"
            "• Users have full control over their data\n\n"
            "For complete privacy policy, visit our website.\n"
            "Contact: privacy@good2good.tech",
            style: TextStyle(fontSize: 14),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }
}
