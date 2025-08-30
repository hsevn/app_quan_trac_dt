import 'package:flutter/material.dart';
import 'dart:io';
import '../data/db_helper.dart';

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
    _loadResults();
  }

  Future<void> _loadResults() async {
    final data = await DBHelper.instance.getAllResults();
    setState(() {
      results = data;
    });
  }

  Future<void> _deleteResult(int id) async {
    await DBHelper.instance.deleteResult(id);
    _loadResults();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kết quả đã nhập')),
      body: results.isEmpty
          ? const Center(child: Text('Chưa có dữ liệu nào.'))
          : ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                final item = results[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text('Vị trí: ${item['position'] ?? '---'}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Ánh sáng: ${item['light'] ?? '---'} | OWAS: ${item['owas'] ?? '---'}'),
                        if (item['image'] != null &&
                            File(item['image']).existsSync())
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Image.file(
                              File(item['image']),
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Xoá kết quả'),
                            content:
                                const Text('Bạn có chắc muốn xoá dòng này?'),
                            actions: [
                              TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text('Huỷ')),
                              TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, true),
                                  child: const Text('Xoá')),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          await _deleteResult(item['id'] as int);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Đã xoá')));
                          }
                        }
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
