import 'package:flutter/material.dart';
import 'package:frontend/Screens/Feed/Post/Components/Comments/tile.dart';

class Commenti extends StatefulWidget
{
  final List<CommentoTile> commenti;
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