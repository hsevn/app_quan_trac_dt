import 'package:flutter/material.dart';

class HDHomePage extends StatelessWidget {
  const HDHomePage({super.key});

  static const List<Map<String, String>> devices = [
    {
      'name': 'Thiết bị đo khí',
      'desc': 'Hướng dẫn sử dụng thiết bị đo khí gas độc hại.',
    },
    {
      'name': 'Máy đo nhiệt độ',
      'desc': 'Hướng dẫn sử dụng thiết bị đo nhiệt độ môi trường.',
    },
    {
      'name': 'Máy đo ánh sáng',
      'desc': 'Hướng dẫn vận hành và hiệu chuẩn máy đo ánh sáng.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hướng Dẫn Thiết Bị')),
      body: ListView.builder(
        itemCount: devices.length,
        itemBuilder: (context, index) {
          final item = devices[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ListTile(
              leading: const Icon(Icons.build_outlined),
              title: Text(item['name']!),
              subtitle: Text(item['desc']!),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // TODO: mở trang chi tiết sau
              },
            ),
          );
        },
      ),
    );
  }
}
