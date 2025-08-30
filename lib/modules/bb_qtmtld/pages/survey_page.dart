import 'package:flutter/material.dart';
import '../data/db_helper.dart';

class SurveyPage extends StatefulWidget {
  const SurveyPage({super.key});

  @override
  State<SurveyPage> createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  String? selectedL1Code, selectedL2Code, selectedL3Code;
  String? selectedL1Name, selectedL2Name, selectedL3Name;

  List<Map<String, dynamic>> l1Areas = [];
  List<Map<String, dynamic>> l2Areas = [];
  List<Map<String, dynamic>> l3Areas = [];

  final TextEditingController lightCtrl = TextEditingController();
  final TextEditingController tempCtrl = TextEditingController();
  final TextEditingController humidityCtrl = TextEditingController();
  final TextEditingController windCtrl = TextEditingController();
  final TextEditingController radiationCtrl = TextEditingController();
  final TextEditingController noiseCtrl = TextEditingController();
  final TextEditingController electricCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadL1();
  }

  Future<void> _loadL1() async {
    final data = await DBHelper.instance.getL1Areas();
    setState(() {
      l1Areas = data;
    });
  }

  Future<void> _loadL2(String l1Code) async {
    final data = await DBHelper.instance.getL2Areas(l1Code);
    setState(() {
      l2Areas = data;
      l3Areas = [];
      selectedL2Code = null;
      selectedL3Code = null;
    });
  }

  Future<void> _loadL3(String l1Code, String l2Code) async {
    final data = await DBHelper.instance.getL3Areas(l1Code, l2Code);
    setState(() {
      l3Areas = data;
      selectedL3Code = null;
    });
  }

  Future<void> _save() async {
    final data = {
      'area_l1': selectedL1Name,
      'area_l2': selectedL2Name,
      'area_l3': selectedL3Name,
      'light': double.tryParse(lightCtrl.text),
      'temperature': double.tryParse(tempCtrl.text),
      'humidity': double.tryParse(humidityCtrl.text),
      'wind_speed': double.tryParse(windCtrl.text),
      'heat_radiation': double.tryParse(radiationCtrl.text),
      'noise_total': double.tryParse(noiseCtrl.text),
      'electric_field': double.tryParse(electricCtrl.text),
    };

    await DBHelper.instance.insertResult(data);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Đã lưu dữ liệu')),
      );
    }
  }

  Widget _buildInput(String label, TextEditingController ctrl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: ctrl,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nhập Kết Quả Quan Trắc'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // Dropdown cấp 1
            DropdownButtonFormField<String>(
              value: selectedL1Code,
              hint: const Text('Chọn L1'),
              isExpanded: true,
              items: l1Areas.map<DropdownMenuItem<String>>((area) {
                return DropdownMenuItem<String>(
                  value: area['L1_CODE'] as String,
                  child: Text(area['L1_NAME'] as String),
                );
              }).toList(),
              onChanged: (value) {
                final name = l1Areas.firstWhere((e) => e['L1_CODE'] == value)['L1_NAME'] as String;
                setState(() {
                  selectedL1Code = value;
                  selectedL1Name = name;
                });
                _loadL2(value!);
              },
            ),
            const SizedBox(height: 10),

            // Dropdown cấp 2
            DropdownButtonFormField<String>(
              value: selectedL2Code,
              hint: const Text('Chọn L2'),
              isExpanded: true,
              items: l2Areas.map<DropdownMenuItem<String>>((area) {
                return DropdownMenuItem<String>(
                  value: area['L2_CODE'] as String,
                  child: Text(area['L2_NAME'] as String),
                );
              }).toList(),
              onChanged: (value) {
                final name = l2Areas.firstWhere((e) => e['L2_CODE'] == value)['L2_NAME'] as String;
                setState(() {
                  selectedL2Code = value;
                  selectedL2Name = name;
                });
                _loadL3(selectedL1Code!, value!);
              },
            ),
            const SizedBox(height: 10),

            // Dropdown cấp 3
            DropdownButtonFormField<String>(
              value: selectedL3Code,
              hint: const Text('Chọn L3'),
              isExpanded: true,
              items: l3Areas.map<DropdownMenuItem<String>>((area) {
                return DropdownMenuItem<String>(
                  value: area['L3_CODE'] as String,
                  child: Text(area['L3_NAME'] as String),
                );
              }).toList(),
              onChanged: (value) {
                final name = l3Areas.firstWhere((e) => e['L3_CODE'] == value)['L3_NAME'] as String;
                setState(() {
                  selectedL3Code = value;
                  selectedL3Name = name;
                });
              },
            ),

            const SizedBox(height: 20),

            _buildInput('Ánh sáng', lightCtrl),
            _buildInput('Nhiệt độ', tempCtrl),
            _buildInput('Độ ẩm', humidityCtrl),
            _buildInput('Tốc độ gió', windCtrl),
            _buildInput('Bức xạ nhiệt', radiationCtrl),
            _buildInput('Tiếng ồn', noiseCtrl),
            _buildInput('Điện trường', electricCtrl),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _save, child: const Text('Lưu')),
          ],
        ),
      ),
    );
  }
}
