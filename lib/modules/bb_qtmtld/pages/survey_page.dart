import 'package:flutter/material.dart';
import '../data/db_helper.dart';

class SurveyPage extends StatefulWidget {
  const SurveyPage({super.key});

  @override
  State<SurveyPage> createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  String? selectedL1;
  String? selectedL2;
  String? selectedL3;

  final TextEditingController lightCtrl = TextEditingController();
  final TextEditingController tempCtrl = TextEditingController();
  final TextEditingController humidityCtrl = TextEditingController();
  final TextEditingController windCtrl = TextEditingController();
  final TextEditingController radiationCtrl = TextEditingController();
  final TextEditingController noiseCtrl = TextEditingController();
  final TextEditingController electricCtrl = TextEditingController();

  String? selectedOWAS;
  String? selectedQuestionOption;
  final TextEditingController questionAnswerCtrl = TextEditingController();

  List<String> levels1 = ['Xưởng Ống Thẳng', 'Xưởng Ống Tròn'];
  List<String> levels2 = ['Khu vực Hàn', 'Khu vực Sản xuất'];
  List<String> levels3 = ['Máy cắt 1', 'Máy ép 1'];

  final List<String> owasOptions = ['Tốt', 'Cần cải thiện', 'Không đạt'];
  final List<String> questionOptions = ['Câu hỏi 1', 'Câu hỏi 2'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nhập Kết Quả Quan Trắc')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: _buildDropdown('Chọn L1', levels1, selectedL1, (val) => setState(() => selectedL1 = val))),
                const SizedBox(width: 8),
                Expanded(child: _buildDropdown('Chọn L2', levels2, selectedL2, (val) => setState(() => selectedL2 = val))),
                const SizedBox(width: 8),
                Expanded(child: _buildDropdown('Chọn L3', levels3, selectedL3, (val) => setState(() => selectedL3 = val))),
              ],
            ),
            const SizedBox(height: 16),
            _buildInput('Ánh sáng', lightCtrl),
            _buildInput('Nhiệt độ', tempCtrl),
            _buildInput('Độ ẩm', humidityCtrl),
            _buildInput('Tốc độ gió', windCtrl),
            _buildInput('Bức xạ nhiệt', radiationCtrl),
            _buildInput('Tiếng ồn', noiseCtrl),
            _buildInput('Điện trường', electricCtrl),
            const SizedBox(height: 16),
            _buildDropdown('Đánh giá OWAS', owasOptions, selectedOWAS, (val) => setState(() => selectedOWAS = val)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildDropdown(
                    'Câu hỏi mẫu',
                    questionOptions,
                    selectedQuestionOption,
                    (val) => setState(() => selectedQuestionOption = val),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(child: _buildInput('Câu trả lời', questionAnswerCtrl)),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final data = {
                  'l1': selectedL1,
                  'l2': selectedL2,
                  'l3': selectedL3,
                  'light': lightCtrl.text,
                  'temperature': tempCtrl.text,
                  'humidity': humidityCtrl.text,
                  'wind': windCtrl.text,
                  'radiation': radiationCtrl.text,
                  'noise': noiseCtrl.text,
                  'electric': electricCtrl.text,
                  'owas': selectedOWAS,
                  'question': selectedQuestionOption,
                  'answer': questionAnswerCtrl.text,
                  'image': null,
                  'timestamp': DateTime.now().toIso8601String(),
                };

                try {
                  final id = await DBHelper().insertResult(data);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('✅ Đã lưu kết quả (ID: $id)')),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('❌ Lỗi lưu: $e')),
                    );
                  }
                }
              },
              child: const Text('Lưu kết quả'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, String? selected, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      value: selected,
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildInput(String label, TextEditingController ctrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: ctrl,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      ),
    );
  }
}
