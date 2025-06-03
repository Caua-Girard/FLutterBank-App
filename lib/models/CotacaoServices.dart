import 'dart:convert';
import 'package:http/http.dart' as http;

class CotacaoService {
  static const _baseUrl = 'https://economia.awesomeapi.com.br/json/last/';

  static Future<double?> buscarCotacao(String moeda) async {
    final url = Uri.parse('$_baseUrl$moeda-BRL');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return double.tryParse(data["${moeda}BRL"]["bid"]);
      } else {
        print('Erro na API: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Erro na requisição: $e');
      return null;
    }
  }
}
