import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/Screens/Common/appbar.dart';
import 'package:frontend/Screens/Common/emptyState.dart';
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
  @override
  Widget build(BuildContext context)
  {
    return FutureBuilder
    (
      future: _fetchPosts(), 
      builder: (context, snapshot)
      {
        if (snapshot.connectionState == ConnectionState.waiting) 
          return Scaffold(body: Center(child: CircularProgressIndicator())); // Placeholder while loading
        if (snapshot.hasError)
            return Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: 
                [
                  EmptyState(
                    icon: Icons.signal_wifi_connected_no_internet_4_rounded,
                    message: 'Errore durante la connessione al server',
                  ),
                  SizedBox(height: 15),
                  ElevatedButton(
                    child: Text("RIPROVA"),
                    onPressed: () => setState((){})
                  )
                ],
              )
            );
        return _buildUI(context, snapshot); // Build the UI using fetched data
      }
    );
  }

  Widget _buildUI(BuildContext context, AsyncSnapshot snapshot)
  {
    return Scaffold(
      appBar: PageTitle(
        title: "Bacheca",
        actions: [
          IconButton(
            icon: Icon(Icons.person_search_rounded),
            onPressed: () => context.push('/searchuser')
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: snapshot.data.isNotEmpty ? 
          ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) => snapshot.data[index]
          )
          :
          EmptyState(
            icon: Icons.landscape_rounded,
            message: 'Ancora nessun post',
          )
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
      String profilepic = (await ApiManager.fetchData("profile/${post['creator']}/profile_image"))!;
      profilepic = json.decode(profilepic)['profile_image_url'];
      result.add(
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

  Future<void> _onRefresh() async{
    setState((){});
  }

}