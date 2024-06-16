import 'package:flutter/material.dart';
import 'package:frontend/Screens/Percorsi/header_percorso.dart';
import 'package:frontend/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _Point {
  final double x;
  final double y;

  const _Point({required this.x, required this.y});

  // Nuovo costruttore che accetta stringhe
  factory _Point.fromString({required double x, required double y}) {
    return _Point(
      x: x,
      y: y,
    );
  }

  @override
  String toString() {
    return 'Point(x: $x, y: $y)';
  }
}

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
  _Point? coords;

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
      coords: _Point(x: json['x'] ?? 0, y: json['y'] ?? 0),
    );
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
      //'coords': coords.toString(),
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
      "http://$myIP:8000/api/uploads/trails/${widget.percorso.imageName ?? ''}",
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
                  if (widget.percorso.title != null &&
                      widget.percorso.title!.isNotEmpty &&
                      widget.percorso.title != 'NaN')
                    ListTile(
                      title: Text(widget.percorso.title ?? '',
                          semanticsLabel: 'Nome',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                  if (widget.percorso.category != null &&
                      widget.percorso.category!.isNotEmpty &&
                      widget.percorso.category != 'NaN')
                    ListTile(
                      leading: Icon(Icons.category),
                      title: Text(
                          "Categoria: ${widget.percorso.category ?? ''}",
                          semanticsLabel: 'Categoria'),
                    ),
                  if (widget.percorso.startpoint != null &&
                      widget.percorso.startpoint!.isNotEmpty &&
                      widget.percorso.startpoint != 'NaN')
                    ListTile(
                      leading: Icon(Icons.location_on),
                      title: Text("Inizio: ${widget.percorso.startpoint ?? ''}",
                          semanticsLabel: 'Inizio'),
                    ),
                  if (widget.percorso.endpoint != null &&
                      widget.percorso.endpoint!.isNotEmpty &&
                      widget.percorso.endpoint != 'NaN')
                    ListTile(
                      leading: Icon(Icons.location_on),
                      title: Text("Fine: ${widget.percorso.endpoint ?? ''}",
                          semanticsLabel: 'Fine'),
                    ),
                  if (widget.percorso.description != null &&
                      widget.percorso.description!.isNotEmpty &&
                      widget.percorso.description != 'NaN')
                    ListTile(
                      leading: Icon(Icons.description),
                      title: Text(
                          "Descrizione: ${widget.percorso.description ?? ''}",
                          semanticsLabel: 'Descrizione'),
                    ),
                  if (widget.percorso.summary != null &&
                      widget.percorso.summary!.isNotEmpty &&
                      widget.percorso.summary != 'NaN')
                    ListTile(
                      leading: Icon(Icons.abc),
                      title: Text("Riassunto: ${widget.percorso.summary ?? ''}",
                          semanticsLabel: 'Riassunto'),
                    ),
                  if (widget.percorso.security != null &&
                      widget.percorso.security!.isNotEmpty &&
                      widget.percorso.security != 'NaN')
                    ListTile(
                      leading: Icon(Icons.security),
                      title: Text(
                          "Sicurezza: ${widget.percorso.security ?? ''}",
                          semanticsLabel: 'Sicurezza'),
                    ),
                  if (widget.percorso.tips != null &&
                      widget.percorso.tips!.isNotEmpty &&
                      widget.percorso.tips != 'NaN')
                    ListTile(
                      leading: Icon(Icons.tips_and_updates),
                      title: Text("Consigli: ${widget.percorso.tips ?? ''}",
                          semanticsLabel: 'Consigli'),
                    ),
                  if (widget.percorso.length != null &&
                      widget.percorso.length!.isNotEmpty &&
                      widget.percorso.length != 'NaN')
                    ListTile(
                      leading: Icon(Icons.linear_scale),
                      title: Text("Lunghezza: ${widget.percorso.length ?? ''}",
                          semanticsLabel: 'Lunghezza'),
                    ),
                  if (widget.percorso.equipment != null &&
                      widget.percorso.equipment!.isNotEmpty &&
                      widget.percorso.equipment != 'NaN')
                    ListTile(
                      leading: Icon(Icons.shield),
                      title: Text(
                          "Attrezzatura: ${widget.percorso.equipment ?? ''}",
                          semanticsLabel: 'Attrezzatura'),
                    ),
                  if (widget.percorso.references != null &&
                      widget.percorso.references!.isNotEmpty &&
                      widget.percorso.references != 'NaN')
                    ListTile(
                      leading: Icon(Icons.book),
                      title: Text(
                          "Riferimenti: ${widget.percorso.references ?? ''}",
                          semanticsLabel: 'Riferimenti'),
                    ),
                  if (widget.percorso.climb != null &&
                      widget.percorso.climb!.isNotEmpty &&
                      widget.percorso.climb != 'NaN')
                    ListTile(
                      leading: Icon(Icons.arrow_upward),
                      title: Text("Salita: ${widget.percorso.climb ?? ''}",
                          semanticsLabel: 'Salita'),
                    ),
                  if (widget.percorso.descent != null &&
                      widget.percorso.descent!.isNotEmpty &&
                      widget.percorso.descent != 'NaN')
                    ListTile(
                      leading: Icon(Icons.arrow_downward),
                      title: Text("Discesa: ${widget.percorso.descent ?? ''}",
                          semanticsLabel: 'Discesa'),
                    ),
                  if (widget.percorso.difficulty != null &&
                      widget.percorso.difficulty!.isNotEmpty &&
                      widget.percorso.difficulty != 'NaN')
                    ListTile(
                      leading: Icon(Icons.terrain),
                      title: Text(
                          "Difficoltà: ${widget.percorso.difficulty ?? ''}",
                          semanticsLabel: 'Difficoltà'),
                    ),
                  if (widget.percorso.duration != null &&
                      widget.percorso.duration!.isNotEmpty &&
                      widget.percorso.duration != 'NaN')
                    ListTile(
                      leading: Icon(Icons.timer),
                      title: Text("Durata: ${widget.percorso.duration ?? ''}",
                          semanticsLabel: 'Durata'),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
