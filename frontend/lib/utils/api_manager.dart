import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'constants.dart';

class ApiManager {
  static String _baseUrl = 'http://$myIP:8000/api';

  static Future<String?> getToken() async 
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("access_token");
  }

  static Future<String?> fetchData(String endpoint) async {
    String accessToken = await getToken() ?? "";

    final response = await http.get(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      print('Errore nella richiesta API: ${response.statusCode}');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> postData(
      String endpoint, Map<String, dynamic> data) async 
  {
    String? token = await getToken();
    final response = await http.post(
      Uri.parse('$_baseUrl/$endpoint'),
      body: json.encode(data),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Se la risposta è 200 (OK), decodifica il JSON e restituisci i dati
      return json.decode(response.body);
    } else {
      // Se la risposta non è 200, gestisci l'errore come preferisci
      print('Errore nella richiesta API: ${response.statusCode}');
      return null;
    }
  }

  static Future<void> deleteData(
      String endpoint, Map<String, dynamic> data) async {
    String? token = await getToken();
    final response = await http.delete(
      Uri.parse('$_baseUrl/$endpoint'),
      body: json.encode(data),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Se la risposta è 200 (OK), decodifica il JSON e restituisci i dati
      return json.decode(response.body);
    } else {
      // Se la risposta non è 200, gestisci l'errore come preferisci
      print('Errore nella richiesta API: ${response.statusCode}');
      return null;
    }
  }
}
