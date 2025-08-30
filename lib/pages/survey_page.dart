import 'package:flutter/material.dart';
import '../data/db_helper.dart';

class SurveyPage extends StatefulWidget {
  const SurveyPage({super.key});

  @override
  State<SurveyPage> createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  final TextEditingController _positionController = TextEditingController();
  final TextEditingController _lightController = TextEditingController();
  final TextEditingController _owasController = TextEditingController();

  Future<void> _saveSurvey() async {
    final data = {
      'position': _positionController.text,
      'light': _lightController.text,
      'owas': _owasController.text,
    };
    final id = await DBHelper.instance.insertResult(data);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã lưu dữ liệu với ID: $id')),
      );
    }

    _positionController.clear();
    _lightController.clear();
    _owasController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nhập Kết Quả'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _positionController,
                decoration: const InputDecoration(labelText: 'Vị trí'),
              ),
              TextField(
                controller: _lightController,
                decoration: const InputDecoration(labelText: 'Ánh sáng'),
              ),
              TextField(
                controller: _owasController,
                decoration: const InputDecoration(labelText: 'OWAS'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveSurvey,
                child: const Text('Lưu kết quả'),
              ),
              const SizedBox(height: 20),
              const Text('Hiển thị dữ liệu dạng bảng:', style: TextStyle(fontWeight: FontWeight.bold)),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Table(
                    border: TableBorder.all(),
                    defaultColumnWidth: const FixedColumnWidth(120),
                    children: const [
                      TableRow(children: [
                        Padding(padding: EdgeInsets.all(8), child: Text('Vị trí')),
                        Padding(padding: EdgeInsets.all(8), child: Text('Ánh sáng')),
                        Padding(padding: EdgeInsets.all(8), child: Text('OWAS')),
                      ]),
                      TableRow(children: [
                        Padding(padding: EdgeInsets.all(8), child: Text('---')),
                        Padding(padding: EdgeInsets.all(8), child: Text('---')),
                        Padding(padding: EdgeInsets.all(8), child: Text('---')),
                      ]),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
