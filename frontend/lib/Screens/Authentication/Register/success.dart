import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegisterSuccessPage extends StatelessWidget
{
  static const route = '/success';

  @override
  Widget build(BuildContext context) {
    return Scaffold
    (
      body: Center
      (
        child: Stack
        (
          alignment: Alignment.center,
          children: 
          [
            Column
            (
              mainAxisSize: MainAxisSize.min,
              children: 
              [
                Icon
                (
                  Icons.check_circle,
                  color: Colors.green,
                  size: 100,
                ),
                SizedBox(height: 10),
                Text
                (
                  'Registrato con successo!',
                  style: TextStyle
                  (
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton
                (
                  child: Text("Login"),
                  onPressed: () => context.go('/login'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}