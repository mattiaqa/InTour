import 'package:flutter/material.dart';
import 'package:frontend/Screens/Percorsi/header_percorso.dart';
import 'package:frontend/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Percorso {
  String? category;
  String? imageName;
  String? title;
  String? summary;
  String? description;
  String? tips;
  String? length;
  String? security;
  String? equipment;
  String? references;
  String? startpoint;
  String? endpoint;
  String? climb;
  String? descent;
  String? difficulty;
  String? duration;
  String? coords;

  Percorso({
    required this.category,
    required this.imageName,
    required this.title,
    required this.summary,
    required this.description,
    required this.tips,
    required this.length,
    required this.security,
    required this.equipment,
    required this.references,
    required this.startpoint,
    required this.endpoint,
    required this.climb,
    required this.descent,
    required this.difficulty,
    required this.duration,
    required this.coords,
  });

  factory Percorso.fromJson(Map<String, dynamic> json) {
    return Percorso(
        category: json['category'] ?? '',
        imageName: json['imageName'] ?? '',
        title: json['title'] ?? '',
        summary: json['summary'] ?? '',
        description: json['description'] ?? '',
        tips: json['tips'] ?? '',
        length: json['length'] ?? '',
        security: json['security'] ?? '',
        equipment: json['equipment'] ?? '',
        references: json['references'] ?? '',
        startpoint: json['startpoint'] ?? '',
        endpoint: json['endpoint'] ?? '',
        climb: json['climb'] ?? '',
        descent: json['descent'] ?? '',
        difficulty: json['difficulty'] ?? '',
        duration: json['duration'] ?? '',
        coords: json['coords'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category ?? '',
      'imageName': imageName,
      'title': title,
      'summary': summary,
      'description': description,
      'tips': tips,
      'length': length,
      'security': security,
      'equipment': equipment,
      'references': references,
      'startpoint': startpoint,
      'endpoint': endpoint,
      'climb': climb,
      'descent': descent,
      'difficulty': difficulty,
      'duration': duration,
      'coords': coords,
    };
  }
}

// ignore: must_be_immutable
class DettagliPercorso extends StatefulWidget {
  final Percorso percorso;

  DettagliPercorso({super.key, required this.percorso});

  @override
  State<DettagliPercorso> createState() => _DettagliPercorsoState();
}

class _DettagliPercorsoState extends State<DettagliPercorso> {
  late Future<Image> _imageFuture;

  @override
  void initState() {
    super.initState();
    _imageFuture = fetchImage();
  }

  Future<Image> fetchImage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("access_token");
    print(token);
    return Image.network(
      "http://$myIP:8000/api/uploads/test/image.jpg",
      headers: {'Authorization': 'Bearer $token'},
      fit: BoxFit.cover,
    );
  }

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
              child: FutureBuilder<Image>(
                future: _imageFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text('Errore nel caricamento dell\'immagine'));
                  } else if (snapshot.hasData) {
                    return snapshot.data!;
                  } else {
                    return Center(child: Text('Nessuna immagine disponibile'));
                  }
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(widget.percorso.title ?? '',
                        semanticsLabel: 'Nome',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  ListTile(
                    leading: Icon(Icons.category),
                    title: Text("Categoria: ${widget.percorso.category ?? ''}",
                        semanticsLabel: 'Categoria'),
                  ),
                  ListTile(
                    leading: Icon(Icons.location_on),
                    title: Text("Inizio: ${widget.percorso.startpoint ?? ''}",
                        semanticsLabel: 'Inizio'),
                  ),
                  ListTile(
                    leading: Icon(Icons.location_on),
                    title: Text("Fine: ${widget.percorso.endpoint ?? ''}",
                        semanticsLabel: 'Fine'),
                  ),
                  ListTile(
                    leading: Icon(Icons.description),
                    title: Text(
                        "Descrizione: ${widget.percorso.description ?? ''}",
                        semanticsLabel: 'Descrizione'),
                  ),
                  ListTile(
                    leading: Icon(Icons.abc),
                    title: Text("Riassunto: ${widget.percorso.summary ?? ''}",
                        semanticsLabel: 'Riassunto'),
                  ),
                  ListTile(
                    leading: Icon(Icons.security),
                    title: Text("Sicurezza: ${widget.percorso.security ?? ''}",
                        semanticsLabel: 'Sicurezza'),
                  ),
                  ListTile(
                    leading: Icon(Icons.tips_and_updates),
                    title: Text("Consigli: ${widget.percorso.tips ?? ''}",
                        semanticsLabel: 'Consigli'),
                  ),
                  ListTile(
                    leading: Icon(Icons.linear_scale),
                    title: Text("Lunghezza: ${widget.percorso.length ?? ''}",
                        semanticsLabel: 'Lunghezza'),
                  ),
                  ListTile(
                    leading: Icon(Icons.shield),
                    title: Text(
                        "Attrezzatura: ${widget.percorso.equipment ?? ''}",
                        semanticsLabel: 'Attrezzatura'),
                  ),
                  ListTile(
                    leading: Icon(Icons.book),
                    title: Text(
                        "Riferimenti: ${widget.percorso.references ?? ''}",
                        semanticsLabel: 'Riferimenti'),
                  ),
                  ListTile(
                    leading: Icon(Icons.arrow_upward),
                    title: Text("Salita: ${widget.percorso.climb ?? ''}",
                        semanticsLabel: 'Salita'),
                  ),
                  ListTile(
                    leading: Icon(Icons.arrow_downward),
                    title: Text("Discesa: ${widget.percorso.descent ?? ''}",
                        semanticsLabel: 'Discesa'),
                  ),
                  ListTile(
                    leading: Icon(Icons.terrain),
                    title: Text(
                        "Difficoltà: ${widget.percorso.difficulty ?? ''}",
                        semanticsLabel: 'Difficoltà'),
                  ),
                  ListTile(
                    leading: Icon(Icons.timer),
                    title: Text("Durata: ${widget.percorso.duration ?? ''}",
                        semanticsLabel: 'Durata'),
                  ),
                  ListTile(
                    leading: Icon(Icons.map),
                    title: Text("Coordinate: ${widget.percorso.coords ?? ''}",
                        semanticsLabel: 'Coordinate'),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
