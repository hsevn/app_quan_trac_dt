import 'package:flutter/material.dart';
import '../db/db_helper.dart';

class ResultsPage extends StatefulWidget {
  const ResultsPage({super.key});

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  List<Map<String, dynamic>> results = [];

  @override
  void initState() {
    super.initState();
    loadResults();
  }

  Future<void> loadResults() async {
    final data = await DBHelper.instance.getAllSurveyResults();
    setState(() {
      results = data;
    });
  }

  Future<void> _deleteResult(int id) async {
    await DBHelper.instance.deleteSurveyResult(id);
    loadResults();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kết Quả Quan Trắc'),
        centerTitle: true,
      ),
      body: results.isEmpty
          ? const Center(child: Text('Chưa có dữ liệu'))
          : ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                final item = results[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text('${item['parameter']} = ${item['value']}'),
                    subtitle: Text(
                      'Vị trí: ${item['l1_code']} / ${item['l2_code']} / ${item['l3_code']}\n'
                      'Tên vị trí cụ thể: ${item['custom_name'] ?? '---'}\n'
                      'Thời gian: ${item['created_at']}',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteResult(item['id']),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
