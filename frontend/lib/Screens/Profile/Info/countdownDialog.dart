import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend/utils/auth_service.dart';
import 'package:go_router/go_router.dart';

class CountdownDialog extends StatefulWidget {
  @override
  _CountdownDialogState createState() => _CountdownDialogState();
}

class _CountdownDialogState extends State<CountdownDialog> {
  int _counter = 10;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_counter > 0) {
          _counter--;
        } else {
          _timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Conferma cancellazione account'),
      content: Text(
        "Sei sicuro di voler cancellare il tuo account?\n"
        "Questa azione rimuoverà tutti i tuoi dati, i tuoi post, le tue amicizie, "
        "i tuoi like e i tuoi commenti.\n"
        "L'azione non è reversibile, neanche per noi!",
        style: TextStyle(fontSize: 16.5),
      ),
      actions: [
        TextButton(
          onPressed: () {
            context.pop();
          },
          child: Text('Annulla'),
        ),
        TextButton(
          onPressed: _counter == 0
              ? () {
                  AuthService.deleteAccount().then(
                    (value) => context.go('/login'),
                  );
                }
              : null,
          child: Text(
            _counter == 0 ? 'Conferma' : 'Conferma (${_counter})',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }
}