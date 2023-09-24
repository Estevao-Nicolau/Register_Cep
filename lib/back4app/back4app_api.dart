import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:register_cep/model/back4app_model.dart';

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
}
