import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/surah.dart';
import '../models/verse.dart';
import '../services/api_service.dart';

class QuranProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<Surah> _surahs = [];
  List<Surah> get surahs => _surahs;

  SurahDetail? _originalSurahDetail; // To keep the original
  SurahDetail? _currentSurahDetail;
  SurahDetail? get currentSurahDetail => _currentSurahDetail;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  String _selectedReciter = '01'; // Default reciter key
  String get selectedReciter => _selectedReciter;
  
  // Reciter names map for UI
  final Map<String, String> reciters = {
    '01': 'Abdullah Al-Juhany',
    '02': 'Abdul Muhsin Al-Qasim',
    '03': 'Abdurrahman as-Sudais',
    '04': 'Ibrahim Al-Dossari',
    '05': 'Misyari Rasyid Al-Afasy',
  };

  QuranProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedReciter = prefs.getString('reciter') ?? '01';
    notifyListeners();
  }

  Future<void> setReciter(String key) async {
    _selectedReciter = key;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('reciter', key);
    notifyListeners();
  }

  Future<void> fetchSurahs() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _surahs = await _apiService.getSurahs();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchSurahDetail(int number) async {
    _isLoading = true;
    _error = null;
    _currentSurahDetail = null; // Clear previous
    notifyListeners();

    try {
      _currentSurahDetail = await _apiService.getSurahDetail(number);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
