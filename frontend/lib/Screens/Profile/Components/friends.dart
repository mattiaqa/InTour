import 'package:flutter/material.dart';
import 'package:frontend/Screens/Common/emptyState.dart';
import 'package:frontend/Screens/Feed/Post/Components/user.dart';
import 'package:frontend/Screens/Profile/Components/profilepic.dart';
import 'package:go_router/go_router.dart';

class FriendsPage extends StatelessWidget
{
  List<List<dynamic>> friendsData;
  FriendsPage({
    required this.friendsData,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Attività'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Amici'),
              Tab(text: 'Inviate'),
              Tab(text: 'Ricevute'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            FriendsList(friendsData[0]),
            SentRequestsList(friendsData[1]),
            ReceivedRequestsList(friendsData[2]),
          ],
        ),
      ),
    );
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
            username: users[index], 
            date: '', 
            image: ''
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
            username: users[index], 
            date: '', 
            image: ''
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
            username: users[index], 
            date: '', 
            image: ''
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
