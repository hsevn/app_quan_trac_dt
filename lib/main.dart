import 'package:flutter/material.dart';
import 'modules/bb_qtmtld/pages/survey_page.dart';
import 'modules/bb_qtmtld/pages/results_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ứng dụng Quan Trắc',
      theme: ThemeData(useMaterial3: true),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const MainMenu(),
        '/survey': (context) => const SurveyPage(),
        '/results': (context) => const ResultsPage(),
      },
    );
  }
}

// ⚠️ Nếu bạn chưa có MainMenu thì tạo mới trong lib/main_menu.dart:
class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menu chính')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('➕ Nhập dữ liệu'),
              onPressed: () => Navigator.pushNamed(context, '/survey'),
            ),
            ElevatedButton(
              child: const Text('📋 Xem kết quả'),
              onPressed: () => Navigator.pushNamed(context, '/results'),
            ),
          ],
        ),
      ),
    );
  }
}
