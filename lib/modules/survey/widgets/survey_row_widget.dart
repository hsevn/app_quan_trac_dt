import 'package:flutter/material.dart';
import 'package:your_app/data/models/survey_row_data.dart';

class SurveyRowWidget extends StatelessWidget {
  final SurveyRowData data;
  final int index;

  const SurveyRowWidget({super.key, required this.data, required this.index});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Dòng ${index + 1}", style: const TextStyle(fontWeight: FontWeight.bold)),
        TextFormField(
          decoration: const InputDecoration(labelText: "Vị trí"),
          onSaved: (val) => data.position = val ?? '',
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: "Ánh sáng"),
          keyboardType: TextInputType.number,
          onSaved: (val) => data.light = double.tryParse(val ?? '') ?? 0,
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: "Nhiệt độ"),
          keyboardType: TextInputType.number,
          onSaved: (val) => data.temp = double.tryParse(val ?? '') ?? 0,
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: "Độ ẩm"),
          keyboardType: TextInputType.number,
          onSaved: (val) => data.humidity = double.tryParse(val ?? '') ?? 0,
        ),
        const Divider(),
      ],
    );
  }
}
