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

  Widget LoginButton = Text('Login');
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        child: AutofillGroup(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/images/InTour_logo.png',
                        height: 100,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "InTour",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 50),
                    TextField(
                      controller: userController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        hintText: "Username",
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword =
                                  !_obscurePassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        hintText: "Password",
                      ),
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      child: LoginButton,
                      onPressed: () {
                        if(LoginButton is CircularProgressIndicator == false)
                          tryLogin(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Non hai un account? ",
                            style: TextStyle(color: Colors.black),
                          ),
                          TextSpan(
                            text: "Registrati",
                            style: TextStyle(color: Colors.blue),
                            recognizer: TapGestureRecognizer()
                              ..onTap =
                                  () => GoRouter.of(context).go("/register"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void tryLogin(BuildContext context) {
    setState(() {
      LoginButton = CircularProgressIndicator();
    });
    AuthService.login(
            userController.text.toString(), passwordController.text.toString())
        .then((value) {
      if (value == 200) {
        _fetchUser(userController.text).then((user) {
          if (user != null) {
            AppService.instance.setUserData(user);
            context.go('/home');
          } else {
            // Gestione errore utente non trovato
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Utente non trovato')),
            );
            setState(() {
              LoginButton = Text('Login');
            });
          }
        });
      } else if (value == 403) {
        // Gestione errore login fallito
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Email o password errati')),
        );
        setState(() {
          LoginButton = Text('Login');
        });
        passwordController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Il server non è al momento ragiungibile, ci scusiamo per il disagio.')),
        );
        setState(() {
          LoginButton = Text('Login');
        });
      }
    });
  }
}

Future<Profile_Data?> _fetchUser(String user) async {
  try {
    final response = await ApiManager.fetchData('profile/$user/data');
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
