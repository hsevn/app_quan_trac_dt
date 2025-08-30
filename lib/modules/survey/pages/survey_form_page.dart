import 'package:flutter/material.dart';
import 'package:your_app/data/models/survey_row_data.dart';
import 'package:your_app/modules/survey/widgets/survey_row_widget.dart';

class SurveyFormPage extends StatefulWidget {
  const SurveyFormPage({super.key});

  @override
  State<SurveyFormPage> createState() => _SurveyFormPageState();
}

class _SurveyFormPageState extends State<SurveyFormPage> {
  final _formKey = GlobalKey<FormState>();
  final List<SurveyRowData> _rows = [SurveyRowData.empty()];

  final TextEditingController controllerNguoiQT = TextEditingController();
  final TextEditingController controllerThoiTiet = TextEditingController();
  final TextEditingController controllerCa = TextEditingController();

  void _addRow() {
    setState(() {
      _rows.add(SurveyRowData.empty());
    });
  }

  void _saveAll() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      for (var r in _rows) {
        debugPrint(r.toMap().toString()); // Sẽ thay bằng lưu SQLite sau
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Đã lưu các dòng đo")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Biên bản QTMT Lao động")),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text("Thông tin chung", style: TextStyle(fontWeight: FontWeight.bold)),
            TextFormField(decoration: const InputDecoration(labelText: "Người QT"), controller: controllerNguoiQT),
            TextFormField(decoration: const InputDecoration(labelText: "Thời tiết"), controller: controllerThoiTiet),
            TextFormField(decoration: const InputDecoration(labelText: "Ca làm việc"), controller: controllerCa),
            const SizedBox(height: 20),
            const Divider(),
            const Text("Danh sách đo:", style: TextStyle(fontWeight: FontWeight.bold)),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _rows.length,
              itemBuilder: (_, i) {
                return SurveyRowWidget(data: _rows[i], index: i);
              },
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _addRow,
                  icon: const Icon(Icons.add),
                  label: const Text("Thêm dòng"),
                ),
                const SizedBox(width: 20),
                ElevatedButton.icon(
                  onPressed: _saveAll,
                  icon: const Icon(Icons.save),
                  label: const Text("Lưu tất cả"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
