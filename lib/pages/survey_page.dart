import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import '../data/db_helper.dart';

class SurveyPage extends StatefulWidget {
  const SurveyPage({super.key});

  @override
  State<SurveyPage> createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  String? selectedL1, selectedL2, selectedL3;
  final l1List = <String>[];
  final l2List = <String>[]; // TODO: update nếu cần
  final l3List = <String>[]; // TODO: update nếu cần

  String? selectedImagePath;

  @override
  void initState() {
    super.initState();
    _loadAreas();
  }

  Future<void> _loadAreas() async {
    final areas = await DBHelper().fetchAreas();
    setState(() {
      l1List.addAll(areas.map((e) => e['name_L1'] as String));
    });
  }

  Future<void> _saveData() async {
    final data = {
      'l1': selectedL1,
      'l2': selectedL2,
      'l3': selectedL3,
      'light': '',
      'temperature': '',
      'humidity': '',
      'wind': '',
      'radiation': '',
      'noise': '',
      'electric': '',
      'owas': '',
      'question': '',
      'answer': '',
      'image': selectedImagePath,
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nhập Kết Quả Quan Trắc')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Row(children: [
            Expanded(
              child: DropdownButton<String>(
                isExpanded: true,
                hint: const Text('Chọn L1'),
                value: selectedL1,
                items: l1List
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
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
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
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
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => selectedL3 = val),
              ),
            ),
          ]),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            icon: const Icon(Icons.camera_alt),
            label: const Text('Chụp / Chọn ảnh'),
            onPressed: () async {
              final result = await FilePicker.platform.pickFiles(type: FileType.image);
              if (result != null && result.files.single.path != null) {
                setState(() {
                  selectedImagePath = result.files.single.path!;
                });
              }
            },
          ),
          if (selectedImagePath != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Image.file(
                File(selectedImagePath!),
                height: 150,
              ),
            ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _saveData,
            child: const Text('Lưu kết quả'),
          ),
        ]),
      ),
    );
  }
}
