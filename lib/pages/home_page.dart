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
  // Dữ liệu từ SQLite
  List<Map<String, dynamic>> allData = [];

  // Danh sách hiển thị theo cấp
  List<String> l1Options = [];
  List<String> l2Options = [];
  List<String> l3Options = [];

  // Giá trị đã chọn
  String? selectedL1;
  String? selectedL2;
  String? selectedL3;

  @override
  void initState() {
    super.initState();
    _loadAreaData();
  }

  Future<void> _loadAreaData() async {
    final data = await DBHelper.instance.fetchAreas();
    setState(() {
      allData = data;
      l1Options = data.map((e) => e['L1_NAME'] as String).toSet().toList()
        ..sort();
    });
  }

  void _updateL2(String l1Name) {
    final l2 = allData
        .where((e) => e['L1_NAME'] == l1Name)
        .map((e) => e['L2_CODE'] as String)
        .toSet()
        .toList()
      ..sort();
    setState(() {
      l2Options = l2;
      selectedL2 = null;
      selectedL3 = null;
      l3Options = [];
    });
  }

  void _updateL3(String l2Code) {
    final l3 = allData
        .where((e) => e['L2_CODE'] == l2Code)
        .map((e) => e['L3_NAME'] as String)
        .toSet()
        .toList()
      ..sort();
    setState(() {
      l3Options = l3;
      selectedL3 = null;
    });
  }

  /// Hộp thoại chọn 1 giá trị từ danh sách
  Future<String?> _pickOne({
    required String title,
    required List<String> items,
    String? current,
  }) async {
    if (items.isEmpty) return null;
    return showDialog<String>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(title),
          content: SizedBox(
            width: 420,
            height: 420,
            child: Scrollbar(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (c, i) {
                  final value = items[i];
                  final selected = value == current;
                  return ListTile(
                    dense: true,
                    title: Text(value),
                    trailing: selected ? const Icon(Icons.check, color: Colors.teal) : null,
                    onTap: () => Navigator.of(ctx).pop(value),
                  );
                },
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Đóng'),
            ),
          ],
        );
      },
    );
  }

  /// Nút chọn dạng button (thân thiện desktop)
  Widget _pickerButton({
    required String label,
    required String hint,
    String? value,
    VoidCallback? onPressed,
    bool enabled = true,
  }) {
    final text = value ?? hint;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 6),
        OutlinedButton(
          onPressed: enabled ? onPressed : null,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            alignment: Alignment.centerLeft,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  text,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: value == null ? Colors.grey : Colors.black,
                  ),
                ),
              ),
              const Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final canPickL2 = selectedL1 != null && l2Options.isNotEmpty;
    final canPickL3 = selectedL2 != null && l3Options.isNotEmpty;

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
            _pickerButton(
              label: 'Cấp L1:',
              hint: 'Chọn cấp L1',
              value: selectedL1,
              onPressed: () async {
                final pick = await _pickOne(
                  title: 'Chọn cấp L1',
                  items: l1Options,
                  current: selectedL1,
                );
                if (pick != null) {
                  setState(() {
                    selectedL1 = pick;
                  });
                  _updateL2(pick);
                }
              },
            ),
            const SizedBox(height: 16),

            _pickerButton(
              label: 'Cấp L2:',
              hint: 'Chọn cấp L2',
              value: selectedL2,
              enabled: canPickL2,
              onPressed: () async {
                final pick = await _pickOne(
                  title: 'Chọn cấp L2',
                  items: l2Options,
                  current: selectedL2,
                );
                if (pick != null) {
                  setState(() {
                    selectedL2 = pick;
                  });
                  _updateL3(pick);
                }
              },
            ),
            const SizedBox(height: 16),

            _pickerButton(
              label: 'Cấp L3:',
              hint: 'Chọn cấp L3',
              value: selectedL3,
              enabled: canPickL3,
              onPressed: () async {
                final pick = await _pickOne(
                  title: 'Chọn cấp L3',
                  items: l3Options,
                  current: selectedL3,
                );
                if (pick != null) {
                  setState(() {
                    selectedL3 = pick;
                  });
                }
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
