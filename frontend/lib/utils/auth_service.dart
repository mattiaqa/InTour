import 'package:flutter/material.dart';
import 'package:frontend/utils/app_service.dart';
import 'package:frontend/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

class Response {
  late bool valid;
  late String body;
  Response(this.valid, this.body);
}

class AuthService {
  static Future<bool> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('http://$myIP:8000/auth/login'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("access_token", data['access_token']);
        return true;
      }
    } catch (e) {
      debugPrint('Errore durante il login: $e');
    }
    return false;
  }


  static Future<Response> register(String email, String name, String surname,
      String username, String password) async {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formattedDate = formatter.format(now);
    print(formattedDate); // something like 2013-04-20
    String error = "";

    try {
      final response = await http.post(
        Uri.parse('http://$myIP:8000/auth/register'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'email': email,
          'name': name,
          'surname': surname,
          'birthdate': formattedDate,
          'password': password,
          'username': username
        }),
      );

      error = response.body;
      if (response.statusCode == 200) {
        return Response(true, response.body);
      }
    } catch (e) {
      debugPrint('Errore durante la fase di registrazione: $e');
    }

    return Response(false, error);
  }

  static Future<bool> logout() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? accessToken = prefs.getString("access_token");
      final response = await http.post(
        Uri.parse('http://$myIP:8000/auth/logout'),
        headers: {"Authorization": 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        await prefs.remove("access_token");
        AppService.instance.manageAutoLogout();
        return true;
      }
    } catch (e) {
      print('Errore durante il logout: $e');
    }
    return false;
  }
}
