import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:frontend/Screens/Common/bottomMessage.dart';
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

  Widget LoadingState = SizedBox(
    width: 20,
    height: 20,
    child: CircularProgressIndicator(),
  );
  Widget ClickableState = SizedBox(
    width: 40,
    height: 20,
    child: Text('Login'),
  );
  late Widget LoginButton;

  bool _obscurePassword = true;

  @override
  void initState() {
    LoginButton = ClickableState;
    super.initState();
  }

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
    if(userController.text.trim().isEmpty || passwordController.text.trim().isEmpty)
    {
      return ShowBottomErrorMessage(context, 'Inserisci username e password');
    }
    setState(() {
      LoginButton = LoadingState;
    });
    AuthService.login(userController.text.trim(), passwordController.text.trim()).then(
      (value) 
      {
        if (value == 200) {
          _fetchUser(userController.text).then((user) {
            if (user != null) {
              AppService.instance.setUserData(user);
              context.go('/home');
            } else {
              ShowBottomErrorMessage(context, 'Utente non trovato');
              setState(() {
                LoginButton = ClickableState;
              });
            }
          });
        } else if (value == 403) {
          ShowBottomErrorMessage(context, 'Email o password errati');
          setState(() {
            LoginButton = ClickableState;
          });
          passwordController.clear();
        } else {
          ShowBottomErrorMessage(context, 'Il server non è al momento ragiungibile, ci scusiamo per il disagio');
          
          setState(() {
            LoginButton = ClickableState;
          });
        }
      }
    );
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
