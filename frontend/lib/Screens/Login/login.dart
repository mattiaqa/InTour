import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:frontend/profile_data.dart';
import 'package:frontend/utils/api_manager.dart';
import 'package:frontend/utils/app_service.dart';
import 'package:frontend/utils/auth_service.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  static const route = '/login';
  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            //title: Text("InTour"),
            ),
        body: Form(
            child: AutofillGroup(
                child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(50),
                child: Text(
                  "InTour",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: TextField(
                  controller: userController,
                  decoration: InputDecoration(
                    hintText: "Username",
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Password",
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(20),
                  child: ElevatedButton(
                    child: Text("Login"),
                    onPressed: () => tryLogin(context),
                  )),
              Padding(
                  padding: EdgeInsets.all(20),
                  child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: "Non hai un account? ",
                          style: TextStyle(color: Colors.black)),
                      TextSpan(
                        text: "Registrati",
                        style: TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => GoRouter.of(context).go("/register"),
                      )
                    ]),
                  ))
            ],
          ),
        ))));
  }

  void tryLogin(BuildContext context) {
    AuthService.login(
            userController.text.toString(), passwordController.text.toString())
        .then((value) {
      if (value) {
        _fetchUser().then((user) {
          if (user != null) {
            AppService.instance.setUserData(user);
            context.go('/home');
          } else {}
        });
      } else {
        /*setState(() {
            borderColor = Color.fromARGB(255, 255, 0, 0);
            errorText = "Email o password errati";
            loginFailed = true;

            passwordController.clear();
          });*/
      }
    });
  }
}

Future<Profile_Data?> _fetchUser() async {
  try {
    final response = await ApiManager.fetchData('profile/data');
    if (response != null) {
      print(json.decode(response));
      final results = json.decode(response);
      if (results.isNotEmpty) {
        return Profile_Data.fromJson(results);
      }
    }
  } catch (e) {
    print('Errore durante il recupero dei dati dell\'utente: $e');
  }
  return null;
}
