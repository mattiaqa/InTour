import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/Screens/Common/appbar.dart';
import 'package:frontend/Screens/Profile/Components/profilepic.dart';
import 'package:frontend/utils/api_manager.dart';
import 'package:go_router/go_router.dart';

class SearchUserPage extends StatefulWidget
{
  const SearchUserPage
  (
    {
      Key? key
    }
  ) : super(key: key);

  @override
  SearchUserPageState createState() => SearchUserPageState();
}

class SearchUserPageState extends State<SearchUserPage>
{
  TextEditingController _searchController = TextEditingController();
  List<SearchResult> _searchResults = [];
  late Completer<void> _searchCompleter = Completer<void>();
  int _searchId = 0;

  @override
  Widget build(BuildContext context)
  {
    return Scaffold
    (
      appBar: PageTitle
      (
        title: 'Ricerca Utente'
      ),
      body: Column
        (
          children: 
          [
            TextField
            (
              controller: _searchController,
              decoration: InputDecoration
              (
                hintText: 'Username',
                contentPadding: EdgeInsets.all(16.0),
              ),
              onChanged: (username) {
                _UpdateUsernames(username);
              },
            ),

            Expanded
            (
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: ProfilePic
                    (
                      imagePath: _searchResults[index].imagePath!,
                      radius: 20,
                    ),
                    title: Text(_searchResults[index].username),
                    onTap: () {
                      context.push('/profilo', extra: _searchResults[index]);
                    },
                  );
                },
              )
            ),
          ],
        ),
    );    
  }

  Future<void> _UpdateUsernames(String query) async {

    final int currentSearchId = ++_searchId;
    final Completer<void> localCompleter = Completer<void>();
    if(_searchCompleter.isCompleted)
      _searchCompleter.complete(); // Completa la ricerca precedente

    _searchCompleter = localCompleter;

    /* ottieni gli usernames e le foto profilo*/
    _searchResults = List.empty(growable: true);
    Map<String, dynamic> data = {
      'query': _searchController.text,
    };
    var res = await ApiManager.postData('profile/search', data);  
    var decoded = json.decode(res!);
    List<String> usernames = List.empty(growable: true);
    List<String> images = List.empty(growable: true);
    for(var i in decoded)
    {
      String username = i["_id"];
      usernames.add(username);
      String userdata = (await ApiManager.fetchData('profile/$username/data'))!;
      String image = (json.decode(userdata))["profile_image_url"];
      images.add(image);
      _searchResults.add(SearchResult(username: username, imagePath: image));
    }

    // Se questa non è la ricerca corrente, interrompi
    if (currentSearchId != _searchId) {
      localCompleter.complete();
      return;
    }

    setState(() {
      if(query.length < 3)
        _searchResults = List.empty();
      //else
        //_searchResults = List.generate(10, (index) => '$query' /* - Risultato $index'*/);
    });
  }
}

class SearchResult
{
  String username;
  String? imagePath;

  SearchResult({
    required this.username,
    this.imagePath
  });
}