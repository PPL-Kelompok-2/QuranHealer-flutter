import 'package:quranhealer/core/init/const/api.dart';
import 'package:dio/dio.dart';

class AdzanService {
  final _dio = Dio();

  Future<List<Map<String, dynamic>>> fetchAdzanData() async {
    try {
      final response = await _dio.get("$adzanAPI/sholat/kota/semua");

      if (response.statusCode == 200) {
        List<dynamic> data = response.data['data'];
        return data
            .map<Map<String, dynamic>>(
                (item) => Map<String, dynamic>.from(item))
            .toList();
      } else {
        throw Exception('Failed to load Adzan List');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }
}
