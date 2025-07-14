import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/character_response.dart';

class CharacterService {
  static Future<CharacterResponse> fetchCharacters(String url) async {
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return CharacterResponse.fromJson(data);
    } else {
      throw Exception('Karakterler yüklenemedi: ${response.statusCode}');
    }
  }
}
