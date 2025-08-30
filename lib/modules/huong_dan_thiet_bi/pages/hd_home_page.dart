import 'package:flutter/material.dart';

class HDHomePage extends StatelessWidget {
  const HDHomePage({super.key});

  static const devices = [
    {
      'name': 'Thiết bị đo khí',
      'desc': 'HDSD thiết bị đo khí gas độc hại.',
    },
    {
      'name': 'Máy đo nhiệt độ',
      'desc': 'HDSD thiết bị đo nhiệt độ môi trường.',
    },
    {
      'name': 'Máy đo ánh sáng',
      'desc': 'Vận hành & hiệu chuẩn máy đo ánh sáng.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hướng Dẫn Thiết Bị')),
      body: ListView.builder(
        itemCount: devices.length,
        itemBuilder: (context, i) {
          final item = devices[i];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ListTile(
              leading: const Icon(Icons.build_outlined),
              title: Text(item['name']!),
              subtitle: Text(item['desc']!),
            ),
          );
        },
      ),
    );
  }
}
