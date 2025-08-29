import 'package:flutter/material.dart';
import '../database_helper.dart';

class AreaListPage extends StatefulWidget {
  const AreaListPage({super.key});

  @override
  State<AreaListPage> createState() => _AreaListPageState();
}

class _AreaListPageState extends State<AreaListPage> {
  List<Map<String, dynamic>> areaList = [];

  @override
  void initState() {
    super.initState();
    loadAreas();
  }

  Future<void> loadAreas() async {
    final data = await DatabaseHelper.instance.fetchAreas();
    setState(() {
      areaList = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách khu vực'),
      ),
      body: ListView.builder(
        itemCount: areaList.length,
        itemBuilder: (context, index) {
          final area = areaList[index];
          return ListTile(
            title: Text(area['L3_NAME'] ?? ''),
            subtitle: Text('${area['L1_NAME']} - ${area['L2_CODE']}'),
          );
        },
      ),
    );
  }
}
