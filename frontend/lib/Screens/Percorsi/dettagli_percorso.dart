import 'package:flutter/material.dart';
import 'package:frontend/Screens/Percorsi/header_percorso.dart';
import 'package:frontend/utils/constants.dart';

class Percorso {
  String? category,
      description,
      startpoint,
      endpoint,
      security,
      summary,
      tips,
      title,
      imageUrl;

  Percorso(
      {this.category,
      this.description,
      this.startpoint,
      this.endpoint,
      this.security,
      this.summary,
      this.tips,
      this.title,
      this.imageUrl});

  factory Percorso.fromJson(Map<String, dynamic> json) {
    return Percorso(
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      startpoint: json['startpoint'] ?? '',
      endpoint: json['endpoint'] ?? '',
      description: json['description'] ?? '',
      security: json['security'] ?? '',
      summary: json['summary'] ?? '',
      tips: json['tips'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title ?? '',
      'category': category ?? '',
      'startpoint': startpoint ?? '',
      'endpoint': endpoint ?? '',
      'description': description ?? '',
      'security': security ?? '',
      'summary': summary ?? '',
      'tips': tips ?? ''
    };
  }
}

// ignore: must_be_immutable
class DettagliPercorso extends StatefulWidget {
  Percorso percorso;

  DettagliPercorso({super.key, required this.percorso});

  @override
  State<DettagliPercorso> createState() => DettagliPercorsoState();
}

class DettagliPercorsoState extends State<DettagliPercorso> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dettagli percorso")),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            floating: false,
            delegate: PercorsoHeader(
              minHeight: 60.0,
              maxHeight: 200.0,
              child: Image.network(
                "http://$myIP:8000/api/uploads/test/image.jpg",
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: Icon(Icons.title),
                        title: Text(widget.percorso.title.toString(),
                            semanticsLabel: 'Nome',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                      ListTile(
                        leading: Icon(Icons.category),
                        title: Text(
                            "Categoria: ${widget.percorso.category.toString()}",
                            semanticsLabel: 'Categoria'),
                      ),
                      ListTile(
                        leading: Icon(Icons.location_on),
                        title: Text(
                            "Inizio: ${widget.percorso.startpoint.toString()}",
                            semanticsLabel: 'Inizio'),
                      ),
                      ListTile(
                        leading: Icon(Icons.location_on),
                        title: Text(
                            "Fine: ${widget.percorso.endpoint.toString()}",
                            semanticsLabel: 'Fine'),
                      ),
                      ListTile(
                        leading: Icon(Icons.description),
                        title: Text(
                            "Descrizione: ${widget.percorso.description.toString()}",
                            semanticsLabel: 'Descrizione'),
                      ),
                      ListTile(
                        leading: Icon(Icons.abc),
                        title: Text(
                            "Riassunto: ${widget.percorso.summary.toString()}",
                            semanticsLabel: 'Riassunto'),
                      ),
                      ListTile(
                        leading: Icon(Icons.security),
                        title: Text(
                            "Sicurezza: ${widget.percorso.security.toString()}",
                            semanticsLabel: 'Sicurezza'),
                      ),
                      ListTile(
                        leading: Icon(Icons.tips_and_updates),
                        title: Text(
                            "Consigli: ${widget.percorso.tips.toString()}",
                            semanticsLabel: 'Consigli'),
                      ),
                      SizedBox(height: 20),
                      if (widget.percorso.imageUrl != null &&
                          widget.percorso.imageUrl!.isNotEmpty)
                        Image.network(widget.percorso.imageUrl!),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
