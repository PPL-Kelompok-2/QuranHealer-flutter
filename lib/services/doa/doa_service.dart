import 'package:quranhealer/core/init/const/api.dart';
import 'package:dio/dio.dart';

class DoaService {
  final _dio = Dio();

  Future<List<Map<String, dynamic>>> fetchDoaData() async {
    try {
      final response = await _dio.get("$doaAPI/api/doaharian");

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data
            .map<Map<String, dynamic>>(
                (item) => Map<String, dynamic>.from(item))
            .toList();
      } else {
        throw Exception('Failed to load Doa List');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }
}
