import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../db/db_helper.dart';

class SurveyPage extends StatefulWidget {
  final String l1, l2, l3;
  const SurveyPage({super.key, required this.l1, required this.l2, required this.l3});

  @override
  State<SurveyPage> createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  final TextEditingController _valueController = TextEditingController();
  final TextEditingController _paramController = TextEditingController();
  final TextEditingController _customNameController = TextEditingController();

  void _saveData() async {
    final param = _paramController.text.trim();
    final value = _valueController.text.trim();
    final customName = _customNameController.text.trim();

    if (param.isEmpty || value.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập đầy đủ thông tin')),
      );
      return;
    }

    final data = {
      'l1_code': widget.l1,
      'l2_code': widget.l2,
      'l3_code': widget.l3,
      'custom_name': customName,
      'parameter': param,
      'value': value,
      'created_at': DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
    };

    await DBHelper.instance.insertSurveyResult(data);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã lưu kết quả')),
    );

    _paramController.clear();
    _valueController.clear();
    _customNameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nhập dữ liệu - ${widget.l3}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _customNameController,
              decoration: const InputDecoration(
                labelText: 'Tên vị trí cụ thể (nhập tay)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _paramController,
              decoration: const InputDecoration(labelText: 'Chỉ tiêu'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _valueController,
              decoration: const InputDecoration(labelText: 'Giá trị đo'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveData,
              child: const Text('Lưu'),
            ),
          ],
        ),
      ),
    );
  }
}
