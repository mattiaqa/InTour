import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/Screens/Common/emptyState.dart';
import 'package:frontend/Screens/Feed/Post/Components/user.dart';
import 'package:frontend/Screens/Profile/Components/profilepic.dart';
import 'package:frontend/utils/api_manager.dart';
import 'package:go_router/go_router.dart';

class FriendsPage extends StatelessWidget
{
  String username;
  FriendsPage({
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder
    (
      future: getFriendsData(username),
      builder: (context, snapshot) => buildUI(context, snapshot)
    );
  }

  Widget buildUI(BuildContext context, AsyncSnapshot snapshot)
  {
    if (snapshot.connectionState == ConnectionState.waiting)
      return Scaffold(body: Center(child:CircularProgressIndicator())); // Placeholder while loading

    if (snapshot.hasError)
      return Center(child: Text('Error: ${snapshot.error}'));
    
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Attività'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Amici'),
              Tab(text: 'Inviate'),
              Tab(
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Ricevute'),
                      ),
                      if (snapshot.data[2].isNotEmpty)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  )
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            FriendsList(snapshot.data[0]),
            SentRequestsList(snapshot.data[1]),
            ReceivedRequestsList(snapshot.data[2]),
          ],
        ),
      ),
    );
  }

  Future<List<List<dynamic>>> getFriendsData(String username) async
  {
    List<List<dynamic>> result = List.empty(growable: true);

    String? response= await ApiManager.fetchData('profile/$username/data');
    Map<String, dynamic> profile = json.decode(response!);

    result.add(profile['friends'] ?? List.empty(growable: true));
    result.add(profile['friends_pending']  ?? List.empty(growable: true));
    result.add(profile['friends_request'] ?? List.empty(growable: true));

    return result;
  }
}

class FriendsList extends StatelessWidget {

  late List<dynamic> users;

  FriendsList(List<dynamic> users)
  {
    this.users = users;
  }

  @override
  Widget build(BuildContext context) {
   return users.isNotEmpty ?
      ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return TinyProfile(
            username: users[index]
          );
        }
      )
      :
      EmptyState
      (
        icon: Icons.person_off_rounded,
        message: "Non c'è nessuno qui",
      );
  }
}

class SentRequestsList extends StatelessWidget {
  late List<dynamic> users;

  SentRequestsList(List<dynamic> users)
  {
    this.users = users;
  }

  @override
  Widget build(BuildContext context) {
   return users.isNotEmpty ?
      ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return TinyProfile(
            username: users[index]
          );
        }
      )
      :
      EmptyState
      (
        icon: Icons.person_off_rounded,
        message: "Non c'è nessuno qui",
      );
  }
}

class ReceivedRequestsList extends StatelessWidget {
  late List<dynamic> users;
  late List<dynamic> pfps;

  ReceivedRequestsList(List<dynamic> users)
  {
    this.users = users;
  }

  @override
  Widget build(BuildContext context) {
   return users.isNotEmpty ?
      ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return TinyProfile(
            username: users[index]
          );
        }
      )
      :
      EmptyState(
        icon: Icons.person_off_rounded,
        message: "Non c'è nessuno qui",
      );
  }
}
