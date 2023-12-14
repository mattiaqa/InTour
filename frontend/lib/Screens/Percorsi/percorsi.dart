import 'package:flutter/material.dart';
import 'package:frontend/Screens/Percorsi/percorso_tile.dart';
import 'package:frontend/utils/api_manager.dart';
import 'dart:convert';

class Percorsi extends StatefulWidget
{
  Percorsi({super.key});
  @override
  State<Percorsi> createState() => PercorsiState();
}

class PercorsiState extends State<Percorsi>
{
  late Future _future;
  List<PercorsoTile> trails = [];


  @override
  void initState() 
  {
    super.initState();
    _future = _fetchPercorsi();
  }

  Future _fetchPercorsi() async 
  {
    var response = await ApiManager.fetchData('trails');
    if (response != null) 
    {
      response = response.replaceAll(' NaN,', '"NaN",');
      var results = jsonDecode(response) as List?;

      if (results != null) 
      {
        return results.map((e) => PercorsoTile.fromJson(e)).toList();
      }
    }
    return [];
  }

  @override
  Widget build(BuildContext context)
  {
    return FutureBuilder
    (
      future: _future, 
      builder: (context, snapshot) 
      {
        if (snapshot.connectionState == ConnectionState.waiting) 
        {
          return const CircularProgressIndicator(); // Placeholder while loading
        } 
        else 
        {
          if (snapshot.hasError) 
          {
            return Text('Error: ${snapshot.error}');
          } 
          else
          {
            trails = snapshot.data;
            /*if (needsRefresh) 
            {
              needsRefresh = false;
              allExams = snapshot.data!;
              exams = allExams;
              visibleExams.clear();
              visibleProve.clear();
            }*/
          }
          return _buildUI(); // Build the UI using fetched data
        }
      }
    );
  }

  Widget _buildUI()
  {
    return ListView.builder
    (
      itemCount: trails.length,
      itemBuilder: (context, index)
      {
        return PercorsoTile
        (
          title: trails[index].title, 
          category: trails[index].category, 
          startpoint: trails[index].startpoint
        );
      },
    );
  }
}