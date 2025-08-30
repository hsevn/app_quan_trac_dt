import 'package:flutter/material.dart';
import 'db_helper.dart';

class SurveyPage extends StatefulWidget {
  const SurveyPage({super.key});
  @override
  State<SurveyPage> createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  String? selectedL1, selectedL2, selectedL3;
  final l1List = <String>[];
  final l2List = <String>[];
  final l3List = <String>[];

  @override
  void initState() {
    super.initState();
    _loadAreas();
  }

  Future<void> _loadAreas() async {
    final areas = await DBHelper().fetchAreas();
    setState(() {
      l1List.addAll(areas.map((e) => e['name_L1'] as String));
      // Tương tự phân loại vào l2List và l3List
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nhập Kết Quả Quan Trắc')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Row(children: [
            Expanded(
              child: DropdownButton<String>(
                isExpanded: true,
                hint: const Text('Chọn L1'),
                value: selectedL1,
                items: l1List
                    .map((e) =>
                        DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => selectedL1 = val),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DropdownButton<String>(
                isExpanded: true,
                hint: const Text('Chọn L2'),
                value: selectedL2,
                items: l2List
                    .map((e) =>
                        DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => selectedL2 = val),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DropdownButton<String>(
                isExpanded: true,
                hint: const Text('Chọn L3'),
                value: selectedL3,
                items: l3List
                    .map((e) =>
                        DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => selectedL3 = val),
              ),
            ),
          ]),
          const SizedBox(height: 20),
          // Các chỉ tiêu đo + nút lưu
        ]),
      ),
    );
  }
}
