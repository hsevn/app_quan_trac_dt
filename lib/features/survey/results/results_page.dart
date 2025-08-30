import 'package:flutter/material.dart';
import 'db_helper.dart';

class ResultsPage extends StatefulWidget {
  const ResultsPage({super.key});
  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  List<Map<String, dynamic>> data = [];

  @override
  void initState() {
    super.initState();
    _loadResults();
  }

  Future<void> _loadResults() async {
    final res = await DBHelper().getAllSurveyResults();
    setState(() => data = res);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kết quả đã nhập')),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          final item = data[index];
          return ListTile(
            title: Text('Area: ${item['areaId']}, Value: ${item['resultValue']}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                await DBHelper().deleteSurveyResult(item['id']);
                _loadResults();
              },
            ),
          );
        },
      ),
    );
  }
}
