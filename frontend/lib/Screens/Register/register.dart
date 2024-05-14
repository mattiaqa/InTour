import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:frontend/profile_data.dart';
import 'package:frontend/utils/api_manager.dart';
import 'package:frontend/utils/app_service.dart';
import 'package:frontend/utils/auth_service.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends StatefulWidget {
  static const route = '/register';
  @override
  State<RegisterPage> createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String errorText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold
    (
      appBar: AppBar
      (
        //title: Text("InTour"),
      ),
      body: Form
      (
        child: AutofillGroup
        (
          child: SingleChildScrollView
          (
            child: Column
            (
              children:
              [
                Padding
                (
                  padding: EdgeInsets.all(50),
                  child: Text
                  (
                    "InTour",
                    style: TextStyle
                    (
                      fontSize: 40,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Padding
                (
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Text
                  (
                    errorText,
                    style: TextStyle
                    (
                      fontSize: 14,
                      color: Colors.redAccent
                    ),
                  ),
                ),
                Padding
                (
                  padding: EdgeInsets.all(20),
                  child: TextField
                  (
                    controller: emailController,
                    decoration: InputDecoration
                    (
                      hintText: "Email",
                    ),
                  ),
                ),
                Padding
                (
                  padding: EdgeInsets.all(20),
                  child: TextField
                  (
                    controller: nameController,
                    decoration: InputDecoration
                    (
                      hintText: "Nome completo",
                    ),
                  ),
                ),
                Padding
                (
                  padding: EdgeInsets.all(20),
                  child: TextField
                  (
                    controller: userController,
                    decoration: InputDecoration
                    (
                      hintText: "Username",
                    ),
                  ),
                ),
                Padding
                (
                  padding: EdgeInsets.all(20),
                  child: TextField
                  (
                    controller: passwordController,
                    obscureText: false,
                    decoration: InputDecoration
                    (
                      hintText: "Password",
                    ),
                  ),
                ),
                Padding
                (
                  padding: EdgeInsets.all(20),
                  child: ElevatedButton
                  (
                    child: Text("Registrati"),
                    onPressed: () => tryRegister(context),
                  )
                ),
                Padding
                (
                  padding: EdgeInsets.all(20),
                  child: RichText
                  (
                    text: TextSpan
                    (
                      children: 
                      [
                        TextSpan
                        (
                          text: "Hai già un account? ",
                          style: TextStyle(color: Colors.black)
                        ),
                        TextSpan
                        (
                          text: "Accedi",
                          style: TextStyle(color: Colors.blue),
                          recognizer: TapGestureRecognizer()..onTap = () => GoRouter.of(context).go("/login"),
                        )
                      ]
                    ),
                  )
                )
              ],
            )
          ),
        )
      )
    );
  }

  void tryRegister(BuildContext context) {
    String fullname = nameController.text.toString();
    int space_index = fullname.indexOf(' ');
    String name = fullname.substring(0, space_index);
    String surname = fullname.substring(space_index + 1);
    
    
    AuthService.register
    (
      emailController.text.toString(),
      name,
      surname,
      userController.text.toString(),
      passwordController.text.toString()
    )
      .then((value) 
      {
        if (value.valid) 
        {
          context.go('/success');
        } 
        else 
        {
          setState(() {
            //borderColor = Color.fromARGB(255, 255, 0, 0);
            errorText = value.body;
            //loginFailed = true;

            passwordController.clear();
          });
        }
      });
  }
}

Future<Profile_Data?> _fetchUser() async {
  try {
    final response = await ApiManager.fetchData('profile/data');
    if (response != null) {
      final List<dynamic> results = json.decode(response);
      if (results.isNotEmpty) {
        return Profile_Data.fromJson(results.first);
      }
    }
  } catch (e) {
    print('Errore durante il recupero dei dati dell\'utente: $e');
  }
  return null;
}