import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/Screens/Common/appbar.dart';
import 'package:frontend/Screens/Feed/Post/post.dart';
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

  @override
  Widget build(BuildContext context)
  {
    return FutureBuilder
    (
      future: _fetchPosts(), 
      builder: (context, snapshot)
      {
        if (snapshot.connectionState == ConnectionState.waiting) 
        {
          return const CircularProgressIndicator(); // Placeholder while loading
        } 
        
        if (snapshot.hasError) 
        {
          return Text('Error: ${snapshot.error}');
        } 
         
        posts = snapshot.data!;
        return _buildUI(); // Build the UI using fetched data
      }
    );
  }

  Widget _buildUI()
  {
    return Scaffold
    (
      appBar: PageTitle
      (
        title: "Bacheca",
        actions: 
        [
          IconButton
          (
            icon: Icon(Icons.search_rounded),
            onPressed: ()
            {
              context.push('/searchuser');
            },
          )
        ],
      ),
      body: ListView.builder
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
      )
    );
    
  }

  Future<List<BachecaTile>> _fetchPosts() async 
  {
    var response = await ApiManager.fetchData('post');
    if (response != null) 
    {
      //response = response.replaceAll(' NaN,', '"NaN",');
      var results = jsonDecode(response) as List?;

      if (results != null) 
      {
       return results.map((elem) => BachecaTile.fromJson(elem)).toList().reversed.toList();
      }
    }
    return [];
  }

}