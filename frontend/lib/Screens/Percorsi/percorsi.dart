import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Percorsi extends StatefulWidget
{
  Percorsi({super.key});
  @override
  State<Percorsi> createState() => PercorsiState();
}

class PercorsiState extends State<Percorsi>
{
  @override
  Widget build(BuildContext context)
  {
    return Container
    (
      child: ElevatedButton
      (
        child: Text("Questi sono i percorsi"), 
        onPressed: () => context.go("/bacheca"),
      )
    );
  }
}