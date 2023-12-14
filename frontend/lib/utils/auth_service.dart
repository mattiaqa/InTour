import 'package:flutter/material.dart';
import 'package:frontend/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthService
{
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
}