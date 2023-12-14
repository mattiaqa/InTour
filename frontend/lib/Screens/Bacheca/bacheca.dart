import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/Screens/Bacheca/bacheca_tile.dart';
import 'package:frontend/utils/api_manager.dart';
import 'package:go_router/go_router.dart';

class Bacheca extends StatefulWidget
{
  Bacheca({super.key});
  @override
  State<Bacheca> createState() => BachecaState();
}

class BachecaState extends State<Bacheca>
{
  late Future _future;
  List<BachecaTile> posts = [];

  @override
  void initState()
  {
    super.initState();
    _future = _fetchPosts();
  }

  Future _fetchPosts() async 
  {
    var response = await ApiManager.fetchData('post');
    if (response != null) 
    {
      //response = response.replaceAll(' NaN,', '"NaN",');
      var results = jsonDecode(response) as List?;

      if (results != null) 
      {
        return results.map((e) => BachecaTile.fromJson(e)).toList();
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
            posts = snapshot.data;
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
      itemCount: posts.length,
      itemBuilder: (context, index)
      {
        return BachecaTile
        (
          username: posts[index].username, 
          date: posts[index].date, 
          imagePath: posts[index].imagePath,
          description: posts[index].description,
          likes: posts[index].likes,
          comments: posts[index].comments,
        );
      },
    );
  }
}