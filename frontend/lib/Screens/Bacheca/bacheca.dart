import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Bacheca extends StatefulWidget
{
  Bacheca({super.key});
  @override
  State<Bacheca> createState() => BachecaState();
}

class BachecaState extends State<Bacheca>
{
  @override
  Widget build(BuildContext context)
  {
    return Container
    (
      child: ElevatedButton
      (
        child: Text("Questa è la bacheca"), 
        onPressed: () => context.go("/percorsi"),
      )
    );
  }
}