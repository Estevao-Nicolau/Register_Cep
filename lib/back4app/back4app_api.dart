import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:register_cep/model/back4app_model.dart';
import 'package:register_cep/model/clients_model.dart';

class Back4appAPI {
  static const String apiUrl = 'https://parseapi.back4app.com/classes/UserData';
  static const String applicationId =
      'NbFW4EMcujrJ7h7wAdVsvYTGAKW5yriFqkIVr256';
  static const String restApiKey = '4hPon8TmHn9Pa8ZzbiLYgFHH6NXDt9TuHnDuj5WQ';

  Future<List<Results>?> fetchData() async {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'X-Parse-Application-Id': applicationId,
        'X-Parse-REST-API-Key': restApiKey,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data.containsKey('results')) {
        List<dynamic> resultsJson = data['results'];
        return resultsJson.map((json) => Results.fromJson(json)).toList();
      } else {
        return null;
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> postData(ClienteModel cliente) async {
    var headers = {
      'X-Parse-Application-Id': applicationId,
      'X-Parse-REST-API-Key': restApiKey,
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'POST', Uri.parse('https://parseapi.back4app.com/classes/UserData'));
    request.body = json.encode({
      "name": cliente.nome,
      "password": 'senha',
      "email": 'testt email',
      "address": {
        "cep": cliente.cep,
        "client": cliente.nome,
        "road": cliente.rua,
        "bairro": cliente.bairro,
        "number": cliente.numero,
        "city": cliente.cidade
      }
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 201) {
      print('Cliente salvo com sucesso.');
    } else {
      print('Erro ao salvar o cliente: ${response.reasonPhrase}');
    }
  }

  Future<void> deleteData(String objectId) async {
    var headers = {
      'X-Parse-Application-Id': applicationId,
      'X-Parse-REST-API-Key': restApiKey,
    };

    var request = http.Request(
      'DELETE',
      Uri.parse('$apiUrl/$objectId'),
    );

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print('Data with objectId $objectId deleted successfully.');
    } else {
      print('Error deleting data: ${response.reasonPhrase}');
    }
  }
}
