import 'package:flutter/material.dart';
import 'package:frontend/Screens/Percorsi/dettagli_percorso.dart';
import 'package:frontend/Screens/Percorsi/percorso_tile.dart';
import 'package:frontend/utils/api_manager.dart';
import 'package:frontend/Screens/Common/appbar.dart';
import 'dart:convert';

import 'package:go_router/go_router.dart';

class Percorsi extends StatefulWidget {
  bool chooseLocationForPosts;
  Percorsi({
    super.key,
    this.chooseLocationForPosts = false
  });
  @override
  State<Percorsi> createState() => PercorsiState();
}

class PercorsiState extends State<Percorsi> {
  late Future _future;
  List<Percorso> trails = [];
  List<Percorso> filteredTrails = [];
  String selectedCategory = ''; // Initially no category selected
  Map<String, IconData> categoryIcons = {
    'Panoramico': Icons.landscape,
    'Mountain Bike': Icons.directions_bike,
    'Ciclabile - Panoramico': Icons.directions,
    'Enogastronomico': Icons.local_bar,
    'Storico-Culturale': Icons.account_balance,
    'Sci': Icons.ac_unit
  }; // Replace with your actual categories and icons

  List<String> categories = [
    'Panoramico',
    'Mountain Bike',
    'Ciclabile - Panoramico',
    'Enogastronomico',
    'Storico-Culturale',
    'Sci'
  ]; // Define your categories here

  @override
  void initState() {
    super.initState();
    _future = _fetchPercorsi();
  }

  Future<List<Percorso>> _fetchPercorsi() async {
    var response = await ApiManager.fetchData('trails');
    if (response != null) {
      response = response.replaceAll(' NaN,', '"NaN",');
      var results = jsonDecode(response) as List?;

      if (results != null) {
        trails = results.map((e) => Percorso.fromJson(e)).toList();
        _filterTrails(
            ''); // Apply initial filter (show all) after fetching data
        return trails;
      }
    }
    return [];
  }

  void _filterTrails(String category) {
    setState(() {
      if (selectedCategory == category) {
        // If the same category is selected again, deselect it
        selectedCategory = '';
        filteredTrails = trails; // Show all trails
      } else {
        selectedCategory = category;
        if (selectedCategory.isEmpty) {
          filteredTrails = trails; // Show all trails
        } else {
          filteredTrails = trails
              .where((trail) => trail.category == selectedCategory)
              .toList();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageTitle(
        title: "Percorsi",
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories.map((category) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _filterTrails(
                            category); // Apply filter on category change
                      });
                    },
                    child: Column(
                      children: [
                        Icon(
                          categoryIcons[category] ?? Icons.category,
                          color: selectedCategory == category
                              ? Color.fromARGB(255, 70, 133, 43)
                              : Colors.grey,
                          size: 30,
                        ),
                        SizedBox(height: 5),
                        Text(
                          category,
                          style: TextStyle(
                            color: selectedCategory == category
                                ? Color.fromARGB(255, 70, 133, 43)
                                : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: _buildUI(), // Build the UI using filtered data
          ),
        ],
      ),
    );
  }

  Widget _buildUI() {
    return ListView.builder(
      itemCount: filteredTrails.length,
      itemBuilder: (context, index) {
        return PercorsoTile(
          title: filteredTrails[index].title,
          category: filteredTrails[index].category,
          startpoint: filteredTrails[index].startpoint,
          imageName: filteredTrails[index].imageName,
          onTap: () => widget.chooseLocationForPosts ? 
            context.pop(filteredTrails[index].title) :
            context.push('/percorso', extra: filteredTrails[index])
        );
      },
    );
  }
}
