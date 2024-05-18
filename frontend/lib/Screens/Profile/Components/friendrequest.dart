import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:frontend/utils/api_manager.dart';
import 'package:frontend/utils/app_service.dart';

enum FriendshipState
{
  sameUser,
  strangers,
  requestSent,
  requestRecieved,
  friends
}


class FirendRequestButton extends StatefulWidget
{
  String username;
  FirendRequestButton
  (
    {
      super.key,
      required this.username
    }
  );

  @override
  FriendRequestButtonState createState() => FriendRequestButtonState();
}

class FriendRequestButtonState extends State<FirendRequestButton>
{
  @override
  Widget build(BuildContext context)
  {
    return FutureBuilder<FriendshipState>
    (
      future: _friendStatus(), 
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Mostra un indicatore di caricamento mentre si ottengono le SharedPreferences
        }

        if (snapshot.hasError) {
          return Text('Errore durante il recupero dello stato di amicizia: ${snapshot.error}');
        }
          
        return SizedBox
        (
          height: 30,
          width: 200,
          child: (snapshot.data == FriendshipState.sameUser) ? 
            ElevatedButton
            (
              onPressed: () {},
              child: Text("Modifica")
            )
            :
            ElevatedButton
            (
              onPressed: () 
              {
                Map<String, dynamic> frienddata = {
                  'username': widget.username,
                };

                if(snapshot.data == FriendshipState.friends)
                {  
                  ApiManager.postData('friends/remove', frienddata).then((value) => setState(() {}));
                }
                else if (snapshot.data == FriendshipState.requestRecieved)
                {
                  ApiManager.postData('friends/accept', frienddata).then((value) => setState(() {
                    
                  }));
                }
                else if (snapshot.data == FriendshipState.requestSent)
                {

                }
                else if (snapshot.data == FriendshipState.strangers)
                {
                  ApiManager.postData('friends/request', frienddata).then((value) => setState((){}));
                }
              },
              child: snapshot.data == FriendshipState.friends ? 
                Text("Rimuovi amicizia")
                :
                snapshot.data == FriendshipState.requestRecieved ?
                Text("Accetta amicizia")
                :
                snapshot.data == FriendshipState.requestSent ?
                Text("Richiesta inviata")
                :
                snapshot.data == FriendshipState.strangers ?
                Text("Aggiungi amico") : Text('Errore')
            )
        );
      }) 
    );
  }

  Future<FriendshipState> _friendStatus() async
  {
    if((widget.username == AppService.instance.currentUser!.userid))
      return FriendshipState.sameUser;
    
    String? data = await ApiManager.fetchData('profile/data');
    Map<String,dynamic> profile = json.decode(data!);

    print(profile['friends'].runtimeType);
    print(profile['friends_request'].runtimeType);

    if(profile['friends'] != null)
    {
      List<dynamic> friends = profile['friends'] as List<dynamic>;
      if(friends.contains(widget.username))
        return FriendshipState.friends;
    }

    if(profile['friends_pending'] != null)
    {
      List<dynamic> friends_to_wait = profile['friends_pending'] as List<dynamic>;
      if(friends_to_wait.contains(widget.username))
        return FriendshipState.requestSent;
    }

    if(profile['friends_request'] != null)
    {
      List<dynamic> friends_to_choose = profile['friends_request'] as List<dynamic>;
      if(friends_to_choose.contains(widget.username))
        return FriendshipState.requestRecieved;
    }

    return FriendshipState.strangers;
  }
}