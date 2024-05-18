import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/Screens/Common/appbar.dart';
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
  List<String> _searchResults = [];
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
                    leading: CircleAvatar
                    (
                      radius: 20,
                      backgroundImage: NetworkImage("https://picsum.photos/200/300"),
                    ),
                    title: Text(_searchResults[index]),
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

    // Simulazione della ricerca con un Future che restituisce una lista di stringhe
    await Future.delayed(Duration(seconds: 1)); // Simulazione di un'operazione asincrona

    // Se questa non è la ricerca corrente, interrompi
    if (currentSearchId != _searchId) {
      localCompleter.complete();
      return;
    }

    setState(() {
      if(query.length < 3)
        _searchResults = List.empty();
      else
        _searchResults = List.generate(10, (index) => '$query' /* - Risultato $index'*/);
    });
  }

}