import 'package:flutter/material.dart';
import 'package:frontend/Screens/Percorsi/header_percorso.dart';

class Percorso
{
  String? category, description, startpoint, endpoint, 
    security, summary, tips, title;

  Percorso({this. category, this. description, this.startpoint,
    this.endpoint, this.security, this.summary, this.tips, this.title});  
  
  factory Percorso.fromJson(Map<String, dynamic> json)
  {
    return Percorso
    (
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      startpoint: json['startpoint'] ?? '',
      endpoint: json['startpoint'] ?? '',
      description: json['description'] ?? '',
      security: json['security'] ?? '',
      summary: json['summary'] ?? '',
      tips: json['tips'] ?? '',
    );
  }

}

// ignore: must_be_immutable
class DettagliPercorso extends StatefulWidget
{
  Percorso percorso;

  DettagliPercorso({super.key, required this.percorso});

  @override
  State<DettagliPercorso> createState() => DettagliPercorsoState();
}

class DettagliPercorsoState extends State<DettagliPercorso>
{
  @override
  Widget build(BuildContext context)
  {
    return Scaffold
    (
      appBar: AppBar(title: Text("Dettagli percorso")),
      body: CustomScrollView
      (
        slivers: 
        [
          SliverPersistentHeader
          (
            pinned: true,
            floating: false,
            delegate: PercorsoHeader(
            minHeight: 60.0,
            maxHeight: 200.0,
            child: Container
            (
              color: Colors.lightBlue, child: Center(child: Text(widget.percorso.title.toString()))
            ),
      ),
          ),

          
        ],

        /*
        child: Column
        (
          children: 
          [
            Text(widget.percorso.title.toString(), semanticsLabel: 'Nome',),
            Text(widget.percorso.category.toString(), semanticsLabel: 'Categoria',),
            Text(widget.percorso.startpoint.toString(), semanticsLabel: 'Inizio',),
            Text(widget.percorso.endpoint.toString(), semanticsLabel: 'Fine',),
            Text(widget.percorso.description.toString(), semanticsLabel: 'Descrizione',),
            Text(widget.percorso.summary.toString(), semanticsLabel: 'Riassunto',),
            Text(widget.percorso.security.toString(), semanticsLabel: 'Sicurezza',),
            Text(widget.percorso.tips.toString(), semanticsLabel: 'Consigli',),
          ].map
          ((elem) =>
            Column
            (
              children:
              [
                Padding
                ( 
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Center
                  (
                    child: Container
                    (
                      child: InputDecorator
                      (
                        decoration: InputDecoration
                        (
                          labelText: elem.semanticsLabel,
                          border: OutlineInputBorder
                          (
                            borderRadius: BorderRadius.circular(10),
                          )
                        ),
                        child: elem,
                      ),
                    ),
                  ),
                ),
                Divider(height: 30,),
              ]
            )
          ).toList()
        ),*/
      )
    );
  }
}