import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
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
    final filtered = allData
        .where((e) => e['L1_NAME'] == l1Name)
        .map((e) => e['L2_CODE'] as String)
        .toSet()
        .toList();
    setState(() {
      l2Options = filtered;
      selectedL2 = null;
      selectedL3 = null;
      l3Options = [];
    });
  }

  void updateL3Options(String l2Code) {
    final filtered = allData
        .where((e) => e['L2_CODE'] == l2Code)
        .map((e) => e['L3_NAME'] as String)
        .toSet()
        .toList();
    setState(() {
      l3Options = filtered;
      selectedL3 = null;
    });
  }

  Widget dropdownAsButton({
    required String hint,
    required String? value,
    required List<String> items,
    required void Function(String) onSelected,
  }) {
    return DropdownButton2<String>(
      customButton: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                value ?? hint,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: value == null ? Colors.grey : Colors.black),
              ),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
      items: items
          .map((e) => DropdownMenuItem<String>(value: e, child: Text(e)))
          .toList(),
      onChanged: (v) {
        if (v != null) onSelected(v);
      },
      dropdownStyleData: const DropdownStyleData(maxHeight: 280, elevation: 8),
      menuItemStyleData: const MenuItemStyleData(height: 42),
      openWithLongPress: false, // click là mở (nếu cần giữ nhấn thì true)
      isExpanded: true,
    );
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Cấp L1:'), const SizedBox(height: 6),
            dropdownAsButton(
              hint: 'Chọn cấp L1',
              value: selectedL1,
              items: l1Options,
              onSelected: (v) {
                setState(() {
                  selectedL1 = v;
                  updateL2Options(v);
                });
              },
            ),
            const SizedBox(height: 16),

            const Text('Cấp L2:'), const SizedBox(height: 6),
            dropdownAsButton(
              hint: 'Chọn cấp L2',
              value: selectedL2,
              items: l2Options,
              onSelected: (v) {
                setState(() {
                  selectedL2 = v;
                  updateL3Options(v);
                });
              },
            ),
            const SizedBox(height: 16),

            const Text('Cấp L3:'), const SizedBox(height: 6),
            dropdownAsButton(
              hint: 'Chọn cấp L3',
              value: selectedL3,
              items: l3Options,
              onSelected: (v) {
                setState(() {
                  selectedL3 = v;
                });
              },
            ),

            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ResultsPage()),
                );
              },
              child: const Text('Xem kết quả đã nhập'),
            ),
            const SizedBox(height: 12),
            if (selectedL1 != null && selectedL2 != null && selectedL3 != null)
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
