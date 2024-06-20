import 'package:flutter/material.dart';

void ShowBottomMessage(BuildContext context, String message)
{
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2)
    ),
  );
}

void ShowBottomErrorMessage(BuildContext context, String message)
{
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: const Color.fromARGB(255, 202, 98, 91),
      duration: Duration(seconds: 2)
    ),
  );
}