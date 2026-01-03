import 'dart:convert';

import 'package:movie_app/core/constants.dart';
import 'package:movie_app/models/movie_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<List<MovieModel>> fetchMovies({String type = 'popular'}) async {
    try {
      final url = Uri.https(
        Uri.parse(AppConstants.baseUrl).authority,
        '${Uri.parse(AppConstants.baseUrl).path}$type',
        {'api_key': AppConstants.apiKey},
      );

      final appResponse = await http.get(url);

      if (appResponse.statusCode == 200) {
        final List result = jsonDecode(appResponse.body)['results'];
        return result.map((json) => MovieModel.fromJson(json)).toList();
      } else {
        print('API error: ${appResponse.statusCode} ${appResponse.body}');
      }
    } catch (e) {
      print(e.toString());
    }
    return [];
  }
}
