import 'package:quranhealer/core/init/const/api.dart';
import 'package:dio/dio.dart';
import 'package:quranhealer/core/init/untils/shared_preference.dart';
import 'package:quranhealer/models/post/post_model.dart';

class PostService {
  static Future<List<Post>> fetchPostData() async {
    String? token = await getToken();
    try {
      final dio = Dio();
      final response = await dio.get("$quranHealerAPI/post",
          options: Options(headers: {
            "accept": "application/json",
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          }));

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data["result"];
        return data.map((item) => Post.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load Post Data');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }
}
