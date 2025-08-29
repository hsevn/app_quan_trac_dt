import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trang chủ - App Quan Trắc'),
      ),
      body: const Center(
        child: Text(
          'Chào mừng bạn đến với App Quan Trắc!',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
