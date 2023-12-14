import 'package:flutter/material.dart';
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
  String trailData = '';


  @override
  void initState() {
    super.initState();

    _future = _fetchPercorsi();
  }

  Future _fetchPercorsi() async 
  {
    var response = await ApiManager.fetchData('trails');
    if (response != null) 
    {
      var results = json.decode(response) as List?;
      print(results);
      if (results != null) 
      {
        //return results.map((e) => ExamTile.fromJson(e)).toList();
        return results.toString();
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
            trailData = snapshot.data;
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
    return Text(trailData);
  }
}