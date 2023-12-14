import 'package:flutter/material.dart';
import 'package:frontend/utils/auth_service.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget
{
  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage>
{
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context)
  {
    return Scaffold
    (
      appBar: AppBar(title: Text("InTour"),),
      body: Form
      (
        child: AutofillGroup
        (
          child: Column
          (
            children: 
            [
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
                  obscureText: true,
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
                  onPressed: () => tryLogin(context),
                  child: Text("Login"))
              )
              
            ],
          ),
        )
      )
    );
  }


  void tryLogin(BuildContext context) {
    AuthService.login(userController.text.toString(), passwordController.text.toString()).then
    (
      (value) 
      {
        if (value)
        {
          context.go("/home");
        }
        else 
        {
          /*setState(() {
            borderColor = Color.fromARGB(255, 255, 0, 0);
            errorText = "Email o password errati";
            loginFailed = true;

            passwordController.clear();
          });*/
        }
      }
    );
  }
}