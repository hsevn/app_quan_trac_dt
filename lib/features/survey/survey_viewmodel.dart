// lib/features/survey/survey_viewmodel.dart

import 'package:flutter/material.dart';
import '../widgets/survey_row_widget.dart';

class SurveyViewModel extends ChangeNotifier {
  final List<SurveyRowWidget> surveyRows = [];

  void addNewRow() {
    surveyRows.add(const SurveyRowWidget());
    notifyListeners();
  }

  void removeRow(int index) {
    surveyRows.removeAt(index);
    notifyListeners();
  }

  void clearAll() {
    surveyRows.clear();
    notifyListeners();
  }

  // TODO: getAllResults(), saveToDB() ...
}
