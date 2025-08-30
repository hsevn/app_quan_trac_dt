import 'package:flutter/material.dart';
import 'survey_page.dart';
import 'results_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trang Chủ')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SurveyPage()),
                );
              },
              child: const Text('Nhập quan trắc'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ResultsPage()),
                );
              },
              child: const Text('Xem kết quả đã nhập'),
            ),
          ],
        ),
      ),
    );
  }
}
