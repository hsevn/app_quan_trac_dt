import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../data/models/area.dart';
import '../../../../data/db_helper.dart';

class SurveyRowWidget extends StatefulWidget {
  final void Function(String imagePath, Position? gps)? onCapture;

  const SurveyRowWidget({super.key, this.onCapture});

  @override
  State<SurveyRowWidget> createState() => _SurveyRowWidgetState();
}

class _SurveyRowWidgetState extends State<SurveyRowWidget> {
  final ScreenshotController _screenshotController = ScreenshotController();

  Area? selectedL1;
  Area? selectedL2;
  Area? selectedL3;
  String? selectedQuestion;
  Position? lastPosition;
  String? imagePath;

  List<Area> l1List = [];
  List<Area> l2List = [];
  List<Area> l3List = [];
  final List<String> questionList = ['Câu hỏi A', 'Câu hỏi B'];

  final TextEditingController answerController = TextEditingController();

  final Map<String, TextEditingController> measureControllers = {
    'ánh sáng': TextEditingController(),
    'nhiệt độ': TextEditingController(),
    'độ ẩm': TextEditingController(),
    'tốc độ gió': TextEditingController(),
    'bức xạ nhiệt': TextEditingController(),
    'tiếng ồn chung': TextEditingController(),
    'ồn giải tần': TextEditingController(),
    'điện trường': TextEditingController(),
    'rung': TextEditingController(),
    'bụi toàn phần': TextEditingController(),
    'khí O2': TextEditingController(),
    'khí CO': TextEditingController(),
    'khí CO2': TextEditingController(),
  };

  @override
  void initState() {
    super.initState();
    _loadL1();
    _getCurrentLocation();
  }

  Future<void> _loadL1() async {
    final data = await DBHelper().getAreasByLevel(1);
    setState(() => l1List = data);
  }

  Future<void> _loadL2(String parentId) async {
    final data = await DBHelper().getAreasByLevel(2, parentId: parentId);
    setState(() {
      l2List = data;
      selectedL2 = null;
      selectedL3 = null;
      l3List.clear();
    });
  }

  Future<void> _loadL3(String parentId) async {
    final data = await DBHelper().getAreasByLevel(3, parentId: parentId);
    setState(() {
      l3List = data;
      selectedL3 = null;
    });
  }

  Future<void> _getCurrentLocation() async {
    bool enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) return;

    LocationPermission perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }

    if (perm != LocationPermission.denied && perm != LocationPermission.deniedForever) {
      final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() => lastPosition = pos);
    }
  }

  Future<void> _captureRow() async {
    final Uint8List? bytes = await _screenshotController.capture(delay: const Duration(milliseconds: 10));
    if (bytes != null) {
      final dir = await getApplicationDocumentsDirectory();
      final fileName = 'survey_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File('${dir.path}/$fileName');
      await file.writeAsBytes(bytes);
      setState(() => imagePath = file.path);

      if (widget.onCapture != null) {
        widget.onCapture!(file.path, lastPosition);
      }

      showDialog(
        context: context,
        builder: (_) => AlertDialog(content: Image.file(file)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: _screenshotController,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            const Text('1'),
            const SizedBox(width: 12),

            DropdownButton<Area>(
              hint: const Text('L1'),
              value: selectedL1,
              items: l1List.map((area) => DropdownMenuItem(value: area, child: Text(area.name))).toList(),
              onChanged: (val) {
                setState(() => selectedL1 = val);
                _loadL2(val!.id);
              },
            ),
            const SizedBox(width: 12),

            DropdownButton<Area>(
              hint: const Text('L2'),
              value: selectedL2,
              items: l2List.map((area) => DropdownMenuItem(value: area, child: Text(area.name))).toList(),
              onChanged: (val) {
                setState(() => selectedL2 = val);
                _loadL3(val!.id);
              },
            ),
            const SizedBox(width: 12),

            DropdownButton<Area>(
              hint: const Text('L3'),
              value: selectedL3,
              items: l3List.map((area) => DropdownMenuItem(value: area, child: Text(area.name))).toList(),
              onChanged: (val) => setState(() => selectedL3 = val),
            ),

            const SizedBox(width: 12),

            ...measureControllers.entries.map((entry) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: SizedBox(
                    width: 70,
                    child: TextField(
                      controller: entry.value,
                      decoration: InputDecoration(labelText: entry.key, border: const OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                )),

            const SizedBox(width: 12),

            ElevatedButton(
              onPressed: _captureRow,
              child: const Text('📷 Chụp hình'),
            ),

            if (lastPosition != null)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text('GPS: ${lastPosition!.latitude.toStringAsFixed(5)}, ${lastPosition!.longitude.toStringAsFixed(5)}'),
              ),

            if (imagePath != null)
              const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Icon(Icons.check_circle, color: Colors.green),
              ),

            const SizedBox(width: 12),

            DropdownButton<String>(
              hint: const Text('Câu hỏi'),
              value: selectedQuestion,
              onChanged: (val) => setState(() => selectedQuestion = val),
              items: questionList.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            ),

            const SizedBox(width: 12),

            SizedBox(
              width: 150,
              child: TextField(
                controller: answerController,
                decoration: const InputDecoration(labelText: 'Trả lời', border: OutlineInputBorder()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
