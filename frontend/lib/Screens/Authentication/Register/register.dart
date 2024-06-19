import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
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
  TextEditingController confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  bool _isValidEmail(String email) {
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return regex.hasMatch(email);
  }

  bool _isValidName(String name) {
    return name.length <= 32;
  }

  bool _isValidUsername(String username) {
    return username.length > 3 &&
        !username.contains('*') &&
        !username.contains("'") &&
        !username.contains('"') &&
        !username.contains(',') &&
        !username.contains('@') &&
        !username.contains('<') &&
        !username.contains('>') &&
        !username.contains('!');
  }

  bool _isValidPassword(String password) {
    return password.length >= 8;
  }

  void tryRegister(BuildContext context) {
    String email = emailController.text.toString();
    String fullname = nameController.text.toString();
    String username = userController.text.toString();
    String password = passwordController.text.toString();
    String confirmPassword = confirmPasswordController.text.toString();

    if (!_isValidEmail(email)) {
      _showError(context, "Email non valida!");
      return;
    }

    if (!_isValidName(fullname)) {
      _showError(context, "Il nome non deve superare i 32 caratteri!");
      return;
    }

    if (!_isValidUsername(username)) {
      _showError(context, "Lo username deve essere più lungo di 3 caratteri e non deve contenere caratteri speciali!");
      return;
    }

    if (!_isValidPassword(password)) {
      _showError(context, "La password deve essere lunga almeno 8 caratteri!");
      return;
    }

    if (password != confirmPassword) {
      _showError(context, "Le password non coincidono!");
      return;
    }

    String surname = ' ';

    AuthService.register(
      email,
      fullname,
      surname,
      username,
      password,
    ).then((value) {
      if (value.valid) {
        context.go('/success');
      } else {
        _showError(context, value.body);
        passwordController.clear();
        confirmPasswordController.clear();
      }
    });
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
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
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 50),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        hintText: "Email",
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        hintText: "Nome completo",
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: userController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person_outline),
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
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        hintText: "Password",
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        hintText: "Conferma Password",
                      ),
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      child: Text("Registrati"),
                      onPressed: () => tryRegister(context),
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
                            text: "Hai già un account? ",
                            style: TextStyle(color: Colors.black),
                          ),
                          TextSpan(
                            text: "Accedi",
                            style: TextStyle(color: Colors.blue),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () =>
                                  GoRouter.of(context).go("/login"),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
