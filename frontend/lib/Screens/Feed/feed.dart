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
  List<BachecaTile> posts = [];

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
          return Center(child: CircularProgressIndicator()); // Placeholder while loading
        } 
        
        if (snapshot.hasError) 
        {
          return Center(child: Text('Error: ${snapshot.error}'));
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
          return posts[index];
        },
      )
    );
    
  }

  Future<List<BachecaTile>> _fetchPosts() async 
  {
    var response = await ApiManager.fetchData('post');
    if (response == null) 
      return [];

    List<dynamic> posts = jsonDecode(response);
    List<BachecaTile> result = List.empty(growable: true);
    for(var post in posts)
    {
      String userdata = (await ApiManager.fetchData("profile/${post['creator']}/data"))!;
      String profilepic = (json.decode(userdata))["profile_image_url"];
      result.add
      (
        BachecaTile(
          id: post['_id'],
          username: post['creator'],
          userimage: profilepic,
          date: post['date'], 
          imagePath: post['img_url'],
          description: post['description'],
          likers: post['like'],
          comments: post['comments'],
        )
      );
    }
    return result.reversed.toList();
  }

}