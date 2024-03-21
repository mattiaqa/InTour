import 'package:flutter/material.dart';
import 'package:frontend/Screens/Bacheca/commento_tile.dart';
import 'package:frontend/Screens/Percorsi/percorso_tile.dart';
import 'package:frontend/utils/api_manager.dart';
import 'dart:convert';

class Commenti extends StatefulWidget
{
  List<CommentoTile> commenti;
  Commenti({super.key, required this.commenti});
  
  @override
  State<Commenti> createState() => CommentiState();
}

class CommentiState extends State<Commenti>
{
  @override
  Widget build(BuildContext context)
  {
    return Scaffold
    (
      appBar: AppBar(title: Text("Commenti")),
      body: ListView.builder
      (
        itemCount: widget.commenti.length,
        itemBuilder: (context, index)
        {
          return CommentoTile
          (
            user: widget.commenti[index].user,
            text: widget.commenti[index].text,
          );
        },
      ),
    ); 
    
    
  }
}