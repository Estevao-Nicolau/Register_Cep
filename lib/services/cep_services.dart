import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:register_cep/model/cep_model.dart';

class CepService {
  final String baseUrl = 'https://viacep.com.br/ws';

  Future<CepModel?> fetchCep(String cep) async {
    final response = await http.get(Uri.parse('$baseUrl/$cep/json'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return CepModel.fromJson(data);
    } else {
      return null; // Trate erros de acordo com sua necessidade
    }
  }
}

