import 'package:flutter/material.dart';
import '../models/input_row_model.dart';

class FormEntryPage extends StatefulWidget {
  const FormEntryPage({super.key});

  @override
  State<FormEntryPage> createState() => _FormEntryPageState();
}

class _FormEntryPageState extends State<FormEntryPage> {
  List<InputRowModel> inputRows = [];

  @override
  void initState() {
    super.initState();
    inputRows.add(InputRowModel()); // Bắt đầu với 1 dòng
  }

  void addRow() {
    setState(() {
      inputRows.add(InputRowModel());
    });
  }

  Widget buildRow(int index) {
    final row = inputRows[index];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: TextFormField(
              decoration: const InputDecoration(labelText: 'Vị trí (Cha)'),
              onChanged: (val) => row.parentPosition = val,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: TextFormField(
              decoration: const InputDecoration(labelText: 'Khu vực (Con)'),
              onChanged: (val) => row.subArea = val,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: TextFormField(
              decoration: const InputDecoration(labelText: 'Nơi cụ thể (Cháu)'),
              onChanged: (val) => row.specificLocation = val,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: TextFormField(
              decoration: const InputDecoration(labelText: 'Chỉ tiêu'),
              onChanged: (val) => row.criteria = val,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 1,
            child: TextFormField(
              decoration: const InputDecoration(labelText: 'Giá trị'),
              keyboardType: TextInputType.number,
              onChanged: (val) => row.value = val,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: TextFormField(
              decoration: const InputDecoration(labelText: 'Ghi chú'),
              onChanged: (val) => row.note = val,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nhập số liệu quan trắc'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: addRow,
            tooltip: 'Thêm dòng',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            for (int i = 0; i < inputRows.length; i++) buildRow(i),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Tạm thời: in log ra console
                for (var row in inputRows) {
                  print(
                      "${row.parentPosition} - ${row.subArea} - ${row.specificLocation} - ${row.criteria} - ${row.value} - ${row.note}");
                }
              },
              child: const Text('Lưu tạm'),
            ),
          ],
        ),
      ),
    );
  }
}
