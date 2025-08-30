import 'package:flutter/material.dart';
import '../../../data/models/survey_row_data.dart';
import '../../../core/database/db_helper.dart';
import '../../survey/widgets/survey_row_widget.dart';

class SurveyFormPage extends StatefulWidget {
  const SurveyFormPage({super.key});

  @override
  State<SurveyFormPage> createState() => _SurveyFormPageState();
}

class _SurveyFormPageState extends State<SurveyFormPage> {
  final _formKey = GlobalKey<FormState>();
  final List<SurveyRowData> _rows = [SurveyRowData.empty()];
  bool _saving = false;

  void _addRow() {
    setState(() => _rows.add(SurveyRowData.empty()));
  }

  Future<void> _saveAll() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      setState(() => _saving = true);

      for (var r in _rows) {
        await DBHelper.instance.insertRow(r);
      }

      setState(() => _saving = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Đã lưu thành công!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Biên bản QTMT Lao động")),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  "Danh sách đo:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _rows.length,
                  itemBuilder: (_, i) => SurveyRowWidget(data: _rows[i], index: i),
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
                      onPressed: _saving ? null : _saveAll,
                      icon: const Icon(Icons.save),
                      label: _saving
                          ? const Text("Đang lưu...")
                          : const Text("Lưu tất cả"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
ElevatedButton(
  onPressed: () => Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const ResultsPage()),
  ),
  child: const Text("Xem kết quả đã lưu"),
),
