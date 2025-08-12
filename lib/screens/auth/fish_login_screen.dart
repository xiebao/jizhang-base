import "package:flutter/material.dart";

class FishLoginScreen extends StatelessWidget {
  const FishLoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: const Center(child: Text("Login Screen")),
    );
  }
}
