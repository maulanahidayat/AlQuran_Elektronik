import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/surah.dart';
import '../models/verse.dart';

class ApiService {
  static const String baseUrl = 'https://equran.id/api/v2';

  Future<List<Surah>> getSurahs() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/surat'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> surahList = data['data'];
        return surahList.map((json) => Surah.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load surahs: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load surahs: $e');
    }
  }

  Future<SurahDetail> getSurahDetail(int number) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/surat/$number'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return SurahDetail.fromJson(data['data']);
      } else {
        throw Exception('Failed to load surah detail: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load surah detail: $e');
    }
  }
}
