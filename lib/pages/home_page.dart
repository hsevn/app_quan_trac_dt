import 'package:flutter/material.dart';
import '../db/db_helper.dart';
import 'survey_page.dart';
import 'results_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> allData = [];

  List<String> l1Options = [];
  List<String> l2Options = [];
  List<String> l3Options = [];

  String? selectedL1;
  String? selectedL2;
  String? selectedL3;

  @override
  void initState() {
    super.initState();
    loadAreaData();
  }

  Future<void> loadAreaData() async {
    final data = await DBHelper.instance.fetchAreas();

    setState(() {
      allData = data;
      l1Options = data.map((e) => e['L1_NAME'] as String).toSet().toList();
    });
  }

  void updateL2Options(String l1Name) {
    final filtered = allData.where((e) => e['L1_NAME'] == l1Name).toList();
    final l2Names = filtered.map((e) => e['L2_CODE'] as String).toSet().toList();

    setState(() {
      l2Options = l2Names;
      selectedL2 = null;
      selectedL3 = null;
      l3Options = [];
    });
  }

  void updateL3Options(String l2Code) {
    final filtered = allData.where((e) => e['L2_CODE'] == l2Code).toList();
    final l3Names = filtered.map((e) => e['L3_NAME'] as String).toSet().toList();

    setState(() {
      l3Options = l3Names;
      selectedL3 = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chọn Vị Trí Quan Trắc'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              isExpanded: true,
              decoration: const InputDecoration(labelText: 'Chọn cấp L1'),
              value: selectedL1,
              items: l1Options
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) {
                selectedL1 = value;
                updateL2Options(value!);
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              isExpanded: true,
              decoration: const InputDecoration(labelText: 'Chọn cấp L2'),
              value: selectedL2,
              items: l2Options
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) {
                selectedL2 = value;
                updateL3Options(value!);
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              isExpanded: true,
              decoration: const InputDecoration(labelText: 'Chọn cấp L3'),
              value: selectedL3,
              items: l3Options
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedL3 = value;
                });
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ResultsPage()));
              },
              child: const Text('Xem kết quả đã nhập'),
            ),
            const SizedBox(height: 12),
            if (selectedL1 != null &&
                selectedL2 != null &&
                selectedL3 != null)
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SurveyPage(
                        l1: selectedL1!,
                        l2: selectedL2!,
                        l3: selectedL3!,
                      ),
                    ),
                  );
                },
                child: const Text('Nhập chỉ tiêu đo'),
              ),
          ],
        ),
      ),
    );
  }
}
