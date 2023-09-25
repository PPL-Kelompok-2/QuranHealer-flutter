import 'package:flutter/material.dart';
import 'package:quranhealer/models/quran/quran_model.dart';
import 'package:quranhealer/services/quran/quran_service.dart';

class QuranViewModel extends ChangeNotifier {
  final QuranService _apiService = QuranService();
  List<QuranModel> _quranlist = [];

  List<QuranModel> get quranlist => _quranlist;

  Future<void> fetchSurahs() async {
    try {
      final List<Map<String, dynamic>> quranData =
          await _apiService.fetchQuranData();

      _quranlist = quranData.map((item) => QuranModel.fromJson(item)).toList();

      notifyListeners();
    } catch (error) {
      throw Exception('Error: $error');
    }
  }
}
