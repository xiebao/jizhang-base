import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  final String url; 
  const WebViewPage({super.key, required this.url});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage>
    with SingleTickerProviderStateMixin {
  late final WebViewController _controller;
  bool _isLoading = true;

  // Animation controller
  late final AnimationController _rotationController;

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() => _isLoading = true);
          },
          onPageFinished: (String url) async {
            setState(() => _isLoading = false);

            await _controller.runJavaScript('''
              if (document.querySelector('meta[name=viewport]') === null) {
                var meta = document.createElement('meta');
                meta.name = 'viewport';
                meta.content = 'width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no';
                document.head.appendChild(meta);
              }
            ''');

            await _controller.runJavaScript('''
              var style = document.createElement('style');
              style.innerHTML = `
                html, body, #app {
                  width: 100vw !important;
                  max-width: 100vw !important;
                  overflow-x: hidden !important;
                  margin: 0 !important;
                  padding: 0 !important;
                }
                * {
                  box-sizing: border-box !important;
                  max-width: 100vw !important;
                  overflow-x: hidden !important;
                }
              `;
              document.head.appendChild(style);
            ''');
          },
          onWebResourceError: (WebResourceError error) {
            if (error.errorCode == -1 ||
                error.description.contains("ERR_CACHE_MISS")) {
              // Show error or reload
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Error loading page!')),
              );
            }
          },
        ),
      )
      ..setUserAgent(
        // You can test different UAs or comment out to use system default
        'Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.0 Mobile/15E148 Safari/604.1',
      )
      ..loadRequest(Uri.parse( widget.url));
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: Column(
        children: [
          // Top status bar placeholder
          Container(
            height: statusBarHeight,
            color: const Color(0xFF181C20),
          ),
          // Main page content
          Expanded(
            child: Stack(
              children: [
                if (!_isLoading) WebViewWidget(controller: _controller),
                if (_isLoading)
                  Center(
                    child: AnimatedBuilder(
                      animation: _rotationController,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle:
                              _rotationController.value * 2 * 3.1415926, // 2π
                          child: child,
                        );
                      },
                                              child: ClipOval(
                          child: Image.asset(
                            'assets/images/logo.jpg',
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
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
}
